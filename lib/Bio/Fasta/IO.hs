module Bio.Fasta.IO
  (readFastaFile,
   readFastaStdin,
   writeFastaFile,
   writeFastaStdout
  )
where

import Conduit
import Bio.BioSeq
import Bio.Fasta
import Bio.Fasta.Parse
import qualified Data.ByteString.Char8 as B
import Data.Conduit.Attoparsec

readFastaFile :: BioSeq a => FilePath -> IO [Fasta a]
readFastaFile = readFasta . sourceFileBS

readFastaStdin :: BioSeq a => IO [Fasta a]
readFastaStdin = readFasta stdinC

readFasta :: BioSeq a => ConduitT () B.ByteString (ResourceT IO) () -> IO [Fasta a]
readFasta res = runConduitRes $ res .| sinkParser fastaParser

writeFastaFile :: BioSeq a => FilePath -> [Fasta a] -> IO ()
writeFastaFile = writeFasta . sinkFileBS

writeFastaStdout :: BioSeq a => [Fasta a] -> IO ()
writeFastaStdout = writeFasta stdoutC

writeFasta :: BioSeq a => ConduitT B.ByteString Void (ResourceT IO) () -> [Fasta a] -> IO ()
writeFasta res fas = runConduitRes $ yieldMany fas .| mapC toByteString .| res
