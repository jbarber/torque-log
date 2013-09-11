package Torque::Log::Entry;
use Moose;
use namespace::autoclean;

=head1 NAME

Torque::Log::Entry

=head1 SYNOPSIS

  use Torque::Log::Entry;
  my $entry = Torque::Log::Entry->new(
    date => DateTime->now,
    type => 'E',
    id   => '1234.server',
    info => {
        user  => 'bob',
        group => 'general',
        ...
    },
  );

=head1 DESCRIPTION

Object for holding information about Torque jobs recorded in the Torque
accounting logs.

Instances are normally created by the L<Torque::Log> module whilst parsing the
Torque accounting files.

=head1 METHODS

=head2 date()

Holds the DateTime representation of when the entry was generated.

=head2 type()

Holds a string representation of the type of record.

=head2 id()

Holds the string representation of the unique job ID.

=head2 info()

Holds a hash reference of the job information.

=head1 SEE ALSO

L<http://www.clusterresources.com/torquedocs21/9.1accounting.shtml>

=head1 AUTHOR

Jonathan Barber - <jonathan.barber@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2013 Jonathan Barber

This library is free software; you can redistribute it and/or modify it under the same terms as Perl itself, either Perl version 5.8.1 or, at your option, any later version of Perl 5 you may have available.

=cut

has 'date' => (is => 'ro', isa => 'DateTime');
has 'type' => (is => 'ro', isa => 'Str');
has 'id'   => (is => 'ro', isa => 'Str');

has 'info' => (
    is      => 'ro',
    isa     => 'HashRef',
    default => sub { {} },
);

__PACKAGE__->meta->make_immutable;

1;
