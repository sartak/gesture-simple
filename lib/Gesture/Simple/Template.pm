package Gesture::Simple::Template;
use Any::Moose;
extends 'Gesture::Simple::Gesture';

use Gesture::Simple::Match;

use constant match_class => 'Gesture::Simple::Match';

has name => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

sub match {
    my $self    = shift;
    my $gesture = shift;

    my $score = $self->score_match($gesture);

    return $self->match_class->new(
        template => $self,
        gesture  => $gesture,
        score    => $score,
    );
}

sub score_match {
    my $self    = shift;
    my $gesture = shift;
    my $score   = 50;

    return $score;
}

__PACKAGE__->meta->make_immutable;
no Any::Moose;

1;

