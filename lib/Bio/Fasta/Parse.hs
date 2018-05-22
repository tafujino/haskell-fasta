module Bio.Fasta.Parse
  (fasta1Parser,
   fastaParser
  )
where

import Prelude hiding (concat, takeWhile, takeWhile1)
import Data.Attoparsec.ByteString.Char8
import Data.Attoparsec.ByteString hiding (takeWhile, takeWhile1)
import Data.Attoparsec.Applicative
import Data.ByteString.Char8 hiding (takeWhile, takeWhile1)
import Bio.Fasta.Fasta

type Seq = String

nameP :: Parser String
nameP = unpack <$> takeWhile1 (not <$> isSpace)

descP :: Parser String
descP = unpack <$> takeWhile (not <$> isEndOfLine')

seqP :: Parser Seq
seqP = (unpack . concat) <$>
       many1 (endOfLine *> takeWhile (inClass' "ABCDEFGHIKLMNPQRSTUVWYZX*-") <* skipSpace')

fasta1Parser :: Parser Fasta
fasta1Parser = Fasta <$>
               (char '>' *> skipSpace' *> nameP) <*> -- unstrict FASTA may contain spaces after '>'
               (skipSpace' *> descP) <*>
               seqP

fastaParser :: Parser [Fasta]
fastaParser = fasta1Parser `sepBy` many' (skipSpace' *> endOfLine) <* skipSpace <* endOfInput
