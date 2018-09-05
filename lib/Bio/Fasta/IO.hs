module Bio.Fasta.IO
  (readFastaFile
  )
where

import Conduit
import Data.Conduit.Attoparsec
import Bio.BioSeq
import Bio.Fasta
import Bio.Fasta.Parse

readFastaFile :: BioSeq a => FilePath -> IO [Fasta a]
readFastaFile path = runConduitRes $ sourceFileBS path .| sinkParser fastaParser
