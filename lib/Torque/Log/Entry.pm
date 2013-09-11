package Torque::Log::Entry;
use Moose;
use namespace::autoclean;

has 'date' => (is => 'rw', isa => 'DateTime');
has 'type' => (is => 'rw', isa => 'Str');
has 'id'   => (is => 'rw', isa => 'Str');

has 'info' => (
    is      => 'rw',
    isa     => 'HashRef',
    default => sub { {} },
);

__PACKAGE__->meta->make_immutable;

1;
