package Gesture::Simple;
use Any::Moose;

use Gesture::Simple::Gesture;
use Gesture::Simple::Template;

our $VERSION = '0.01';

use constant gesture_class => 'Gesture::Simple::Gesture';

has templates => (
    is         => 'ro',
    isa        => 'ArrayRef',
    default    => sub { [] },
    auto_deref => 1,
);

sub has_templates { @{ shift->templates } > 0 }

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

    confess "You have no templates to match against!"
        unless $self->has_templates;

    $gesture = $self->gesture_class->new(points => $gesture)
        if !blessed($gesture);

    my @matches = sort { $b->score <=> $a->score }
                  map { $_->match($gesture) }
                  $self->templates;

    return @matches if wantarray;
    return $matches[0];
}

__PACKAGE__->meta->make_immutable;
no Any::Moose;

1;

