#!/usr/bin/env perl
use strict;
use warnings;
use Any::Moose;

has templates => (
    is      => 'ro',
    isa     => 'ArrayRef',
    default => sub { [] },
);

sub add_template {
    my $self = shift;
    push @{ $self->templates }, @_;
}

__PACKAGE__->meta->make_immutable;
no Any::Moose;

