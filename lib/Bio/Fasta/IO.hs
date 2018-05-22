module Bio.Fasta.IO
  (readFastaFile
  )
where

import Conduit
import Data.Conduit.Attoparsec
import Data.Attoparsec.ByteString.Char8
import Bio.Fasta.Fasta
import Bio.Fasta.Parse

readFastaFile :: FilePath -> IO [Fasta]
readFastaFile path = runConduitRes $ sourceFileBS path .| sinkParser fastaParser
