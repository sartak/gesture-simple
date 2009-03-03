package Gesture::Simple::Match;
use Any::Moose;

has gesture => (
    is       => 'ro',
    isa      => 'ArrayRef',
    required => 1,
);

has template => (
    is       => 'ro',
    isa      => 'Gesture::Simple::Template',
    required => 1,
);

has score => (
    is       => 'ro',
    isa      => 'Num',
    required => 1,
);

__PACKAGE__->meta->make_immutable;
no Any::Moose;

1;

