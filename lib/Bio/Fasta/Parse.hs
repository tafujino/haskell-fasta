module Bio.Fasta.Parse
  (fasta1Parser,
   fastaParser
  )
where

import Prelude hiding (takeWhile)
import Bio.Fasta
import Control.Monad
import Data.Attoparsec.Applicative
import Data.Attoparsec.ByteString.Char8
import qualified Data.ByteString.Char8 as B8
import qualified Data.Text as T
import Data.Text.Encoding

nameP :: Parser T.Text
nameP = decodeUtf8 <$> takeWhile1 (not <$> isSpace)

descP :: Parser T.Text
descP = T.stripEnd . decodeUtf8 <$> takeWhile (not <$> isEndOfLine')

-- input characters should be checked in the downstream
seqP :: Parser B8.ByteString
seqP = B8.concat <$>
       many1 (takeWhile1 (not <$> isSpace) <* skipSpace' <* endOfLine)

fasta1Parser :: Parser Fasta
fasta1Parser = Fasta <$>
               -- unstrict FASTA may contain spaces after '>'
               (char '>' *> skipSpace' *> nameP) <* skipSpace' <*>
               descP <* endOfLine <*>
               seqP

fastaParser :: Parser [Fasta]
fastaParser = many1 fasta1Parser <* skipSpace <* endOfInput
