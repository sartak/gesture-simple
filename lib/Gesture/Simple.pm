package Gesture::Simple;
use Any::Moose;

use Gesture::Simple::Template;

has templates => (
    is         => 'ro',
    isa        => 'ArrayRef',
    default    => sub { [] },
    auto_deref => 1,
);

sub add_template {
    my $self = shift;

    for (@_) {
        blessed($_) && $_->isa('Gesture::Simple::Template')
            or confess "$_ is not a Gesture::Simple::Template.";
    }

    push @{ $self->templates }, @_;
}

sub match {
    my $self    = shift;
    my $gesture = shift;

    my @matches = map { $_->match($gesture) } $self->templates;
    return sort { $b->score <=> $a->score } @matches;
}

__PACKAGE__->meta->make_immutable;
no Any::Moose;

1;

