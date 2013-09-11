package Torque::Log;
use Moose;
use DateTime::Format::Strptime;
use Torque::Log::Entry;
use namespace::autoclean;

=head1 NAME

Torque::Log

=head1 SYNOPSIS

  use Torque::Log;
  open my $f, '<', "logfile";
  my $logs = Torque::Log->new->parse($f);
  my ($entry) = $logs->get_entries;

  my $entry = Torque::Log->new->parse_line($log_file_line)

=head1 METHODS

=head1 entries( )

Torque::Log::Entry's held by the object.

=cut

has 'entries' => (
    is      => 'rw',
    isa     => 'ArrayRef[Torque::Log::Entry]',
    default => sub { [] },
);

=head1 dateparser( $format )

Instance of DateTime::Format::Strptime for parsing the time at which a log entry is from.

The default instance parses the following pattern:
  %m/%d/%Y %H:%M:%S

And will C<croak> if it can't parse dates in the log entries with this format.

=cut

has 'dateparser' => (
    is      => 'rw',
    isa     => 'DateTime::Format::Strptime',
    default => sub {
        DateTime::Format::Strptime->new(
            pattern  => '%m/%d/%Y %H:%M:%S',
            on_error => 'croak',
        );
    },
);

=head2 parse($filehandle)

Parses a log file read from $filehandle. Returns the Torque::Log instance.

=cut

sub parse {
    my ($self, $fh) = @_;
    while (my $line = <$fh>) {
        $self->parse_line($line);
    }
    return $self;
}

=head2 parse_line($log_line)

Parses a log file line from $log_line, returns the Torque::Log::Entry instance.

=cut

sub parse_line {
    my ($self, $line) = @_;

    chomp $line;
    my ($datetime, $type, $id, $info) = split /;/, $line, 4;

    my $dt = $self->dateparser->parse_datetime($datetime);

    my @info = split /\s+/, $info;
    my %info = map { split /=/, $_, 2 } @info;

    return $self->add_entry(
        Torque::Log::Entry->new(
            date => $dt,
            type => $type,
            id   => $id,
            info => \%info,
        )
    );
}

=head2 add_entry( @log_entries )

Adds instances of Torque::Log::Entry to the collection of log entries.

Returns these entries.

=cut

sub add_entry {
    my ($self, @entries) = @_;
    push @{ $self->entries }, @entries;
}

=head2 get_entries()

Return all of the Torque::Log::Entry instances parsed by the object.

=cut

sub get_entries {
    my ($self) = @_;
    return @{ $self->entries };
}

__PACKAGE__->meta->make_immutable;

=head1 AUTHOR

Jonathan Barber - jonathan.barber@gmail.com

=cut

1;
