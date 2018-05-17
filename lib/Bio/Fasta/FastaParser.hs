module Bio.Fasta.FastaParser
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

type NASeq = String

-- original isSpace gives True when EOL is input
isSpace' :: Char -> Bool
isSpace' = (== ' ') <||> (== '\t')

-- original isEndOfLine has type Word8 -> Bool
isEndOfLine' :: Char -> Bool
isEndOfLine' = (== '\n') <||> (== '\r')

nameP :: Parser String
nameP = unpack <$> takeWhile1 (not <$> isSpace)

descP :: Parser String
descP = unpack <$> takeWhile (not <$> isEndOfLine')

-- currently sequence string is unchecked (may contain non-nucleic or non-amino acid characters)
seqP :: Parser NASeq
seqP = (unpack . concat) <$> many1 (endOfLine *> takeWhile (not <$> isEndOfLine' <&&> (/= '>')))

fasta1Parser :: Parser Fasta
fasta1Parser = Fasta <$>
               (char '>' *> takeWhile isSpace' *> nameP) <*> -- unstrict FASTA may contain spaces after '>'
               (takeWhile isSpace' *> descP) <*>
               seqP

fastaParser :: Parser [Fasta]
fastaParser = many' (many' endOfLine *> fasta1Parser)
