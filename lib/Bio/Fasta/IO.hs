module Bio.Fasta.IO
  (readFastaFile
  )
where

import Conduit
import Data.Conduit.Attoparsec
import Bio.Fasta
import Bio.Fasta.Parse

readFastaFile :: FilePath -> IO [Fasta]
readFastaFile path = runConduitRes $ sourceFileBS path .| sinkParser fastaParser
