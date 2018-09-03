import Bio.Fasta
import Bio.Fasta.IO

main :: IO ()
main = do
  fas <- readFastaFile "test/data/example.fasta"
  print fas
