cd /mnt/sdb/share/amplicondata/20240412/run2-44/01.barcodeQC/0412-1/
perl /mnt/sdb/share/bin/data-split-v4/bin/split.amplicon.barcode.pl 0412-1.barcode.txt /mnt/sdb/zengl/diversity-data/20240412/run2-44/0412-1_R1.fq.gz /mnt/sdb/zengl/diversity-data/20240412/run2-44/0412-1_R2.fq.gz /mnt/sdb/share/amplicondata/20240412/run2-44/01.barcodeQC/0412-1.R1.fq /mnt/sdb/share/amplicondata/20240412/run2-44/01.barcodeQC/0412-1.R2.fq

java -jar /mnt/sdb/share/bin/data-split-v4/bin/trimmomatic-0.30.jar PE -phred33 -threads 12 DB0907.R1.fq DB0907.R2.fq 338F-806R.DB0907.trim.1.fq 338F-806R.DB0907.s.1.fq 338F-806R.DB0907.trim.2.fq 338F-806R.DB0907.s.2.fq LEADING:0 TRAILING:20 SLIDINGWINDOW:10:20 MINLEN:75 2>338F-806R.DB0907.trim.log
rm 338F-806R.DB0907.s.1.fq 338F-806R.DB0907.s.2.fq
/mnt/sdb/zengl/lib/anaconda/envs/qiime2-2020.11/bin/cutadapt -g ACTCCTACGGGAGGCAGCA -G GGACTACHVGGGTWTCTAAT --trimmed-only --action mask -o 338F-806R.DB0907.primer.1.fq -p 338F-806R.DB0907.primer.2.fq 338F-806R.DB0907.trim.1.fq 338F-806R.DB0907.trim.2.fq >338F-806R.DB0907.cutadapt.log
/mnt/sdb/share/bin/data-split-v4/bin/flash -m 10 -M 100 -x 0.2 -p 33 -t 16 -d /mnt/sdb/share/amplicondata/20240412/run2-44/02.flash/0412-1 -o 338F-806R.DB0907.pri 338F-806R.DB0907.primer.1.fq 338F-806R.DB0907.primer.2.fq >338F-806R.DB0907.merge.log
perl /mnt/sdb/share/bin/data-split-v4/bin/filter.flash.N.pl /mnt/sdb/share/amplicondata/20240412/run2-44/02.flash/0412-1/338F-806R.DB0907.pri.extendedFrags.fastq /mnt/sdb/share/amplicondata/20240412/run2-44/03.valid/0412-1/338F-806R.DB0907.flash 460
rm 338F-806R.DB0907.trim.1.fq 338F-806R.DB0907.trim.2.fq 338F-806R.DB0907.primer.1.fq 338F-806R.DB0907.primer.2.fq /mnt/sdb/share/amplicondata/20240412/run2-44/02.flash/0412-1/338F-806R.DB0907.pri.extendedFrags.fastq
source activate qiime1
head -220000 /mnt/sdb/share/amplicondata/20240412/run2-44/03.valid/0412-1/338F-806R.DB0907.flash.fa >/mnt/sdb/share/amplicondata/20240412/run2-44/03.valid/0412-1/338F-806R.DB0907.flash.fa.p
identify_chimeric_seqs.py -i /mnt/sdb/share/amplicondata/20240412/run2-44/03.valid/0412-1/338F-806R.DB0907.flash.fa.p -o /mnt/sdb/share/amplicondata/20240412/run2-44/03.valid/0412-1 -m usearch61 -r /mnt/sdb/share/bin/data-split-v4/data/gold.fa --non_chimeras_retention intersection
conda deactivate
perl /mnt/sdb/share/bin/data-split-v4/bin/getFqSeq_byName.pl /mnt/sdb/share/amplicondata/20240412/run2-44/03.valid/0412-1/338F-806R.DB0907.flash.fq /mnt/sdb/share/amplicondata/20240412/run2-44/03.valid/0412-1/non_chimeras.txt /mnt/sdb/share/amplicondata/20240412/run2-44/03.valid/0412-1/338F-806R.DB0907.no.chimeras.fq
mv /mnt/sdb/share/amplicondata/20240412/run2-44/03.valid/0412-1/non_chimeras.txt /mnt/sdb/share/amplicondata/20240412/run2-44/03.valid/0412-1/338F-806R.DB0907.non_chimeras.txt
wc -l /mnt/sdb/share/amplicondata/20240412/run2-44/03.valid/0412-1/338F-806R.DB0907.non_chimeras.txt |awk '{print $1}' > /mnt/sdb/share/amplicondata/20240412/run2-44/03.valid/0412-1/338F-806R.DB0907.no.chimeras.numstat
