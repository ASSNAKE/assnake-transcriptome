import os

index_dir = config['bwa_index_dir']
fna_db_dir= config['fna_db_dir']

rule salmon_index:
    input: 
        cds_fna   = os.path.join(fna_db_dir, '{path}/{seq_set_id}.fna')
    output: 
        index     = os.path.join(index_dir, 'salmon/{path}/{seq_set_id}/mphf.bin')
    params:
        index_dir = os.path.join(index_dir, 'salmon/{path}/{seq_set_id}/')
    conda: 'env_v1.1.0.yaml'
    threads: 8
    shell: 'salmon index -t {input.cds_fna} -i {params.index_dir} -p {threads}'

rule salmon_quant:
    input: 
        r1 = '{fs_prefix}/{df}/reads/{preproc}/{sample}_R1.fastq.gz',
        r2 = '{fs_prefix}/{df}/reads/{preproc}/{sample}_R2.fastq.gz',
        index = os.path.join(index_dir, 'salmon/{path}/{seq_set_id}/mphf.bin')
    output: '{fs_prefix}/{df}/salmon__v1.1.0/{path}/{seq_set_id}/{preproc}/{sample}/quant.sf'
    params: 
        index_dir = os.path.join(index_dir, 'salmon/{path}/{seq_set_id}/'),
        out_dir = '{fs_prefix}/{df}/salmon__v1.1.0/{path}/{seq_set_id}/{preproc}/{sample}/'
    conda: 'env_v1.1.0.yaml'
    threads: 4
    shell: 'salmon quant -i {params.index_dir} -l A -1 {input.r1} -2 {input.r2} -p {threads} --validateMappings -o {params.out_dir}'