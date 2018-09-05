import Bio.BioSeq
import Bio.BioSeq.DNASeq
import Bio.Fasta
import Bio.Fasta.IO

main :: IO ()
main = do
  seq <- readFastaFile "test/data/example.fasta" :: IO [Fasta DNASeq]
  print seq
