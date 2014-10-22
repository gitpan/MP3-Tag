package Music_Translate_Fields;
use strict;

my %tr;

sub translate_tr ($) {
  my $a = shift;
  $a =~ s/^\s+//;
  $a =~ s/\s+$//;
  $a =~ s/\s+/ /g;
  $a =~ s/\b(\w)\.\s*/$1 /g;
  $a = $tr{lc $a} or return;
  return $a;
}

sub translate_artist ($$) {
  my ($self, $a) = (shift, shift);
  my $ini_a = $a;
  $a = $a->[0] if ref $a;		# [value, handler]
  my $tr_a = translate_tr $a;
  if (not $tr_a and $a =~ /(.*?)\s*,\s*(.*)/s) {	# Schumann, Robert
    $tr_a = translate_tr "$2 $1";
  }
  $a = $tr_a or return $ini_a;
  return ref $ini_a ? [$a, $ini_a->[1]] : $a;
}

sub translate_name ($$) {
  my ($self, $n) = (shift, shift);
  my $ini_n = $n;
  $n = $n->[0] if ref $n;		# [value, handler]
  $n =~ s/\bOp([.\s]\s*|.?(?=\d))/Op. /gi;
  $n =~ s/\bN[or]([.\s]\s*|.?(?=\d))/No. /gi;	# nr12
  $n =~ s/(\W)#\s*(?=\d)/${1}No. /gi;	# #12
  $n =~ s/[.,;]\s*Op\./; Op./gi;	# #12
  return ref $ini_n ? [$n, $ini_n->[1]] : $n;
}

*translate_album = \&translate_name;
*translate_title = \&translate_name;

my %aliases = (	Rachmaninov	=>	[qw(Rachmaninoff Rahmaninov)],
		Tchaikovskiy 	=>	'Chaikovskiy',
		'Mendelssohn-Bartholdy'	=> 'Mendelssohn',
		Shostakovich	=>	['SCHOSTAKOVICH', 'Schostakowitsch',
					 'Shostakovitch'],
		Schnittke	=>	'Shnitke',
		Prokofiev	=>	'Prokofev',
		Stravinsky	=>	'Stravinskiy',
		Scriabin	=>	'Skryabin',
		Liszt		=>	'List',
	      );

for (<DATA>) {
  next if /^\s*$/;
  s/^\s+//, s/\s+$//, s/\s+/ /g;
  #warn "Doing `$_'";
  my ($pre, $post) = /^(.*?)\s*(\(.*\))?$/;
  my @f = split ' ', $pre or warn("`$pre' won't split"), die;
  my $last = pop @f;
  my @last = $last;
  (my $ascii = $last) =~
	tr(������������������������������������������������������������������������������������������������\x80-\x9F)
	  ( !cLXY|S"Ca<__R~o+23'mP.,1o>...?AAAAAAACEEEEIIIIDNOOOOOx0UUUUYpbaaaaaaaceeeeiiiidnooooo:ouuuuyPy_);
  push @last, $ascii unless $ascii eq $last;
  my $a = $aliases{$last[0]} ? $aliases{$last[0]} : [];
  $a = [$a] unless ref $a;
  push @last, @$a;
  for my $last (@last) {
    my @comp = (@f, $last);
    $tr{"\L@comp"} = $_;
    $tr{lc $last} ||= $_;		# Two Bach's
    $tr{"\L$f[0] $last"} ||= $_;
    if (@f) {
      my @ini = map substr($_, 0, 1), @f;
      $tr{"\L$ini[0] $last"} ||= $_;	# One initial
      $tr{"\L@ini $last"} ||= $_;	# All initials
    }
  }
}

for ('Frederic Chopin', 'Fryderyk Chopin', 'Joseph Haydn', 'J Haydn',
     'Sergei Prokofiev', 'Serge Prokofiev', 'Antonin Dvor�k', 'Peter Tchaikovsky',
     'Sergei Rahmaninov', 'Piotyr Ilyich Tchaikovsky',
     'Aleksandr Skryabin', 'Aleksandr Mosolov',
     'DIMITRI SCHOSTAKOVICH', 'Dmitri Schostakowitsch',
     'Dmitri Shostakovich', 'Dmitry Shostakovich',
     'Nicolas Rimsky-Korsakov') {
  my ($last) = (/(\w+)$/) or warn, die;
  $tr{lc $_} = $tr{lc $last};
}

#$tr{lc 'Tchaikovsky, Piotyr Ilyich'} = $tr{lc 'Tchaikovsky'};

# Old misspellings
$tr{lc 'Petr Ilyich Chaikovskiy (1840-1893)'} = $tr{lc 'Tchaikovsky'};
$tr{lc 'Franz Josef Haydn (1732-1809)'} = $tr{lc 'Haydn'};
$tr{lc 'F�lix Mendelssohn (1809-1847)'} = $tr{lc 'Mendelssohn-Bartholdy'};
$tr{lc 'Sergei Rachmaninov (1873-1943)'} = $tr{lc 'Rachmaninov'};
$tr{lc 'Wolfgang Amadei Mozart (1756-1791)'} = $tr{lc 'Mozart'};
$tr{lc 'Eduard Grieg (1843-1907)'} = $tr{lc 'Grieg'};
$tr{lc 'Antonin Dvor�k (1841-1904)'} = $tr{lc 'Dvor�k'};
$tr{lc 'Antonin Dvorak (1841-1904)'} = $tr{lc 'Dvor�k'};
$tr{lc 'Nicolas Rimsky-Korsakov (1844-1908)'} = $tr{lc 'Rimsky-Korsakov'};

1;
__DATA__

Ludwig van Beethoven (1770-1827)
Alfred Schnittke (1934-1998)
Franz Schubert (1797-1828)
Fr�d�ric Chopin (1810-1849)
Petr Ilyich Tchaikovsky (1840-1893)
Robert Schumann (1810-1856)
Sergey Rachmaninov (1873-1943)
Alfredo Catalani (1854-1893)
Amicare Ponchielli (1834-1886)
Gaetano Donizetti (1797-1848)
George Frideric H�ndel (1685-1759)
Gioacchino Rossini (1792-1868)
Giovanni Battista Pergolesi (1710-1736)
Giuseppe Verdi (1813-1901)
Johann Sebastian Bach (1685-1750)
Johann Christian Bach (1735-1782)
Ludwig van Beethoven (1770-1827)
Luigi Cherubini (1760-1842)
Pietro Mascagni (1863-1945)
Riccardo Zandonai (1883-1944)
Richard Wagner (1813-1883)
Ruggiero Leoncavallo (1858-1919)
Umberto Giordano (1867-1948)
Wolfgang Amadeus Mozart (1756-1791)
Edvard Grieg (1843-1907)
Johannes Brahms (1833-1897)
Dmitriy Shostakovich (1906-1975)
Franz Joseph Haydn (1732-1809)
Antonio Vivaldi (1678-1741)
Claude Debussy (1862-1918)
Anton�n Dvor�k (1841-1904)
Antonin Dvor�k (1841-1904)
Antonin Dvorak (1841-1904)
Sergey Prokofiev (1891-1953)
Alfred Schnittke (1934-1998)
Alexander Glazunov (1865-1936)
George Phillipe Telemann (1681-1767)
Jiri Antonin Benda (1722-1795)
Mario Castelnuovo-Tedesco (1895-1968)
Heitor Villa-Lobos (1887-1959)
Hector Berlioz (1803-1869)
Modest Mussorgsky (1839-1881)
George Gershwin (1898-1937)
Carl Orff (1895-1982)
Maurice Ravel (1875-1937)
Isao Matsushita (1951-)
Dietrich Erdmann (1917-)
Paul Dessau (1894-1979)
Erwin Shuloff (1894-1942)
F�lix Mendelssohn-Bartholdy (1809-1847)
Dmitry Stepanovich Bortnyansky (1751-1825)
Kurt Weill (1900-1950)
Jean Sibelius (1865-1957)
Franz Liszt (1811-1886)
Domenico Scarlatti (1685-1757)
Alessandro Scarlatti (1660-1725)
Muzio Clementi (1752-1832)
Anatoly Lyadov (1855-1914)
Arnold Schoenberg (1874-1951)
Georges Bizet (1838-1875)
Alexander Borodin (1833-1887)
Alexander Glazunov (1865-1936)
Gabriel Faur� (1845-1924)
B�la Bart�k (1881-1945)
Camille Saint-Saens (1835-1921)
Benjamin Godard (1849-1895)
Ernest Chausson (1855-1899)
Igor Stravinsky (1882-1971)
Luigi Boccherini (1743-1805)
Richard Strauss (1864-1949)
Paul Hindemith (1895-1963)
Hugo Wolf (1860-1903)
Carl Loewe (1796-1869)
Christoph Willibald von Gluck (1714-1787)
Henry Purcell (1659-1695)
Gustav Mahler (1860-1911)
Michael Haydn (1737-1806)
Marin Marais (1656-1728)
Tomaso Albinoni (1671-1751)
Johann Pachelbel (1653-1706)
Jacques Offenbach (1819-1880)
Bedrich Smetana (1824-1884)
Frederick Delius (1862-1934)
Emmanuel Chabrier (1841-1894)
Carl Maria von Weber (1786-1826)
Johann I Strauss (1804-1849)
Johann II Strauss (1825-1899)
Cesar Franck (1822-1890)
Alexander Scriabin (1872-1915)
Anton Webern (1883-1945)
Edward Elgar (1857-1934)
Mario Castelnuovo-Tedesco (1895-1968)
Nicolai Medtner (1880-1951)
Manuel de Falla (1876-1946)
Joaquin Nin (1879-1949)
Darius Milhaud (1892-1974)
Anton Arensky (1861-1906)
Nicolay Andreevich Rimsky-Korsakov (1844-1908)
Erich Wolfgang Korngold (1897-1957)
Pablo de Sarasate (1844-1908)
Alexandre Tansman (1897-1986)
Max Bruch (1838-1920)
Henri Vieuxtemps (1820-1881)
Ernst von Dohnanyi (1877-1960)
Arthur Benjamin (1893-1960)
Reinhold Gliere (1875-1956)
Henryk Wieniawski (1835-1880)
Giovanni Sgambati (1841-1914)
William Walton (1902-1983)
Louis Gruenberg (1884-1964)

Alexander Mosolov (1900-1973)
Andrey Osypovich Sychra (1773-1850)
Ignatz von Held
Vasily Sergeevich Alferiev
Vladimir Ivanovich Morkov (1801-1864)
Mikhail Timofeevich Vysotsky (1791-1837)
Nikolai Ivanovich Alexandrov (1818-1885/1886)

Lina Bruna Rasa (1907-1984)
Enrico Caruso (1873-1921)
Sviatoslav Richter (1915-1997)
Glenn Gould (1932-1982)
Edit Piaf (1915-1963)
Oleg Kagan (1946-1990)
David Oistrach (1908-1974)
Vladimir Horowitz (1903-1989)
Vladimir Sofronitsky (1901-1961)
Emil Gilels (1916-1985)
Pablo Casals (1876-1973)
Artur Rubinstein (1887-1982)
Jacqueline du Pr� (1945-1987)
Yehudi Menuhin (1916-1999)
Kathleen Ferrier (1912-1953)
Thomas Beecham (1879-1961)
Gregor Piatigorsky (1903-1976)
Yascha Heifetz (1901-1987)
Herbert von Karajan (1908-1989)

Ivan Krylov (1769-1844)
Samuil Marshak (1887-1964)
