package Gesture::Simple::Template;
use Any::Moose;

use Gesture::Simple::Match;

use constant match_class => 'Gesture::Simple::Match';

has name => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has points => (
    is       => 'ro',
    isa      => 'ArrayRef',
    required => 1,
);

sub match {
    my $self    = shift;
    my $gesture = shift;

    my $score = 0;

    return $self->match_class->new(
        template => $self,
        gesture  => $gesture,
        score    => $score,
    );
}

__PACKAGE__->meta->make_immutable;
no Any::Moose;

1;

