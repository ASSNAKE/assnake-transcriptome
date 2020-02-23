index_dir = config['bwa_index_dir']
fna_db_dir = config['fna_db_dir']

rule index_fasta_hisat2:
    input:
        fasta = os.path.join(fna_db_dir, '{path}/{seq_set_id}.fna'),
        gtf_annotation = os.path.join(fna_db_dir, '{path}/{seq_set_id}.gtf')
    output:
        # indexes = os.path.join(index_dir, "hisat2/{path}/{seq_set_id}"),
        splicesites = os.path.join(fna_db_dir,  "{path}/{seq_set_id}/splicesites.txt"),
        done = os.path.join(index_dir, 'hisat2/{path}/{seq_set_id}/index_hisat2.done')
    params:
        index = os.path.join(index_dir, "hisat2/{path}/{seq_set_id}/index")
    conda: 'hisat2_env.yaml'
    threads: 8
    shell:
        "hisat2-build -p {threads} {input.fasta} {params.index}"
        "&& hisat2_extract_splice_sites.py {input.gtf_annotation} > {output.splicesites} && touch {output.done}"

rule map_on_reference_hisat2:
    input:
        index_done = os.path.join(index_dir, 'hisat2/{path}/{seq_set_id}/index_hisat2.done'),
        splicesites = os.path.join(fna_db_dir,  "{path}/{seq_set_id}/splicesites.txt"),
        forward = '{fs_prefix}/{df}/reads/{preproc}/{sample}_R1.fastq.gz',
        reverse = '{fs_prefix}/{df}/reads/{preproc}/{sample}_R2.fastq.gz',
    output:
        sam = '{fs_prefix}/{df}/mapped/hisat2__def/{path}/{seq_set_id}/{sample}/{preproc}/{sample}.sam',
        # bam = '{fs_prefix}/{df}/mapped/hisat2__def/{path}/{seq_set_id}/{sample}/{preproc}/mapped.bam'
    params:
        index = os.path.join(index_dir, "hisat2/{path}/{seq_set_id}/index")
    # benchmark: intermediate_path + "/benchmarks/{sample}.hisat2.benchmark.txt"
    threads: 8
    conda: 'hisat2_env.yaml'
    shell: """export PERL5LIB='';\n
    hisat2 -p {threads} --known-splicesite-infile {input.splicesites} -x {params.index} -1 {input.forward} -2 {input.reverse} -S {output.sam}"""
        # shell("samtools view -@ {threads} -b -S {output.sam} > {output.bam}")

# rule samtools_sam_to_bam:
#     input: sam = '{fs_prefix}/{df}/mapped/hisat2__def/{path}/{seq_set_id}/{sample}/{preproc}/{sample}.sam'
#     output: bam = '{fs_prefix}/{df}/mapped/hisat2__def/{path}/{seq_set_id}/{sample}/{preproc}/{sample}.bam'
#     conda: 'hisat2_env.yaml'
#     threads: 8
#     shell: ("samtools view -@ {threads} -b -S {input.sam} > {output.bam}")

# rule sort_BAM:
#     input: bam = '{fs_prefix}/{df}/mapped/hisat2__def/{path}/{seq_set_id}/{sample}/{preproc}/{sample}.bam'
#     output: sort = '{fs_prefix}/{df}/mapped/hisat2__def/{path}/{seq_set_id}/{sample}/{preproc}/{sample}.sort.bam'
#     conda: 'hisat2_env.yaml'
#     threads: 8
#     shell:
#         "samtools sort -@ {threads} {input.bam} -o {output.sort}"

rule feature_count:
    input:
        sort = '{fs_prefix}/{df}/mapped/{mapper}__def/{path}/{seq_set_id}/{sample}/{preproc}/{sample}.bam',
        gtf_annotation = os.path.join(fna_db_dir, '{path}/{seq_set_id}.gtf')
    output:
        count         = '{fs_prefix}/{df}/mapped/{mapper}__def/{path}/{seq_set_id}/{sample}/{preproc}/{sample}_feature_counts.tsv',
        # count_summary = '{fs_prefix}/{df}/mapped/hisat2__def/{path}/{seq_set_id}/{sample}/{preproc}/{sample}_feature_counts.tsv.summary'
    conda: 'hisat2_env.yaml'
    threads: 8
    shell: ("featureCounts -p -T {threads} -t gene -g gene_id  -a {input.gtf_annotation} -o {output.count} {input.sort}")
    #  && tail -n +3 {output.count} \
    #     | cut -f1,7 > temp.{wildcards.sample} && mv temp.{wildcards.sample} {output.count}")
