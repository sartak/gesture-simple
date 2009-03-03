package Gesture::Simple::Gesture;
use Any::Moose;

has points => (
    is       => 'ro',
    isa      => 'ArrayRef',
    required => 1,
);

__PACKAGE__->meta->make_immutable;
no Any::Moose;

1;

