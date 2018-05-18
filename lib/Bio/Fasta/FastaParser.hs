module Bio.Fasta.FastaParser
  (fasta1Parser,
   fastaParser
  )
where

import Prelude hiding (concat, takeWhile, takeWhile1)
import Control.Monad
import Data.Attoparsec.ByteString.Char8
import Data.Attoparsec.ByteString hiding (takeWhile, takeWhile1)
import Data.Attoparsec.Applicative
import Data.ByteString.Char8 hiding (takeWhile, takeWhile1)
import Bio.Fasta.Fasta

type NASeq = String

-- original isSpace gives True when EOL is input
isSpace' :: Char -> Bool
isSpace' = (== ' ') <||> (== '\t')

-- original skipSpace skips EOLs
skipSpace' :: Parser ()
skipSpace' = void $ takeWhile isSpace'

-- original isEndOfLine has type Word8 -> Bool
isEndOfLine' :: Char -> Bool
isEndOfLine' = (== '\n') <||> (== '\r')

nameP :: Parser String
nameP = unpack <$> takeWhile1 (not <$> isSpace)

descP :: Parser String
descP = unpack <$> takeWhile (not <$> isEndOfLine')

seqP :: Parser NASeq
seqP = (unpack . concat) <$>
       many1 (endOfLine *> takeWhile (inClass' "ABCDEFGHIKLMNPQRSTUVWYZX*-") <* skipSpace')

fasta1Parser :: Parser Fasta
fasta1Parser = Fasta <$>
               (char '>' *> takeWhile isSpace' *> nameP) <*> -- unstrict FASTA may contain spaces after '>'
               (skipSpace' *> descP) <*>
               seqP

fastaParser :: Parser [Fasta]
fastaParser = many' (many' endOfLine *> fasta1Parser)
