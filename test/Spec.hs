import Bio.Fasta.Fasta
import Bio.Fasta.FastaParser

import Conduit
import Data.Conduit.Attoparsec

main :: IO ()
main = do
  fas <- runConduitRes $
         sourceFileBS "test/data/example.fasta" .|  
         sinkParser fastaParser
  print fas
