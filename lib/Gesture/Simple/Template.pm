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

    my $raw_score = $self->score_match($gesture);

    # XXX: 100 -> $size
    my $normalized_score = 1 - $raw_score / 0.5 * sqrt(100*2 + 100*2);

    return $self->match_class->new(
        template => $self,
        gesture  => $gesture,
        score    => $normalized_score,
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

