module Bio.Fasta.Parse
  (fasta1Parser,
   fastaParser
  )
where

import qualified Data.Attoparsec.ByteString.Char8 as A8
import Control.Monad
import Data.Attoparsec.Applicative
import Data.ByteString.Char8 as B8
import Data.Text.Encoding
import qualified Data.Text as T
import Bio.Fasta.Fasta

nameP :: A8.Parser T.Text
nameP = decodeUtf8 <$> A8.takeWhile1 (not <$> A8.isSpace)

descP :: A8.Parser T.Text
descP = T.stripEnd  . decodeUtf8 <$> A8.takeWhile (not <$> isEndOfLine')

-- input characters should be checked in the downstream
seqP :: A8.Parser ByteString
seqP = B8.concat <$>
       A8.many1 (A8.takeWhile1 (not <$> A8.isSpace) <* skipSpace' <* A8.endOfLine)

fasta1Parser :: A8.Parser Fasta
fasta1Parser = Fasta <$>
               -- unstrict FASTA may contain spaces after '>'
               (A8.char '>' *> skipSpace' *> nameP) <* skipSpace' <*>
               descP <* A8.endOfLine <*>
               seqP

fastaParser :: A8.Parser [Fasta]
fastaParser = A8.many1 fasta1Parser <* A8.skipSpace <* A8.endOfInput
