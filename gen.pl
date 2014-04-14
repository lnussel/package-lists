#! /usr/bin/perl

use File::Basename;

my $file = $ARGV[0] || die 'need file';
my $arch = $ARGV[1] || die 'need arch';

sub read_file_recursively($) {
  my $tfile = shift;
  my @lines;
  open(my $fh, '<', $tfile);

  while ( <$fh> ) {
    chomp;

    my $line = $_;

    if ($line =~ m/^#INCLUDE\s*(\S+)/) {
      push(@lines, "\n# from $1\n");
      push(@lines, read_file_recursively(dirname($file) . "/" . $1));
      push(@lines, "# end $1\n\n");
      next;
    }

    if ($line =~ m/#.*!$arch/) {
      next;
    }
    push(@lines, $line);
  }

  close($fh);

  return @lines;
}

open(OUT, ">t");
print OUT "repo openSUSE:Factory-standard-$arch 0 solv trees/openSUSE:Factory-standard-$arch.solv\n";
for my $line (read_file_recursively($file)) {
  print OUT "$line\n";
}
close(OUT);

open(TS, "testsolv -r t|");
my @installs;
while ( <TS> ) {
  if (/^install (.*)-[^-]+-[^-]+\.(\S*)@/) {
	push(@installs, $1);
	print "T $1\n";
  } else {
	print $_;
	exit(1);
  }
}
close(TS);
open(OUT, ">", "output/$file.$arch.list");
for my $pkg (sort @installs) {
  print OUT "$pkg\n";
}
close(OUT);

