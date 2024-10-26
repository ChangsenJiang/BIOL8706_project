import os
import random
import shutil

# 源文件夹和目标文件夹的路径
source_folder = r'd:\naturebird\data\14972_exon_alns'
destination_folder = r'd:\BIOL8706_project\data\exon_full_species'


# 获取源文件夹中的所有文件
fasta_files = [f for f in os.listdir(source_folder) if f.endswith('.fasta')]

# 随机选择100个文件
random_files = random.sample(fasta_files, 100)

# 复制选中的文件到目标文件夹
for file in random_files:
    shutil.copy(os.path.join(source_folder, file), os.path.join(destination_folder, file))