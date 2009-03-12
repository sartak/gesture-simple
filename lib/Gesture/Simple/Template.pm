package Gesture::Simple::Template;
use Any::Moose;
extends 'Gesture::Simple::Gesture';
use Scalar::Defer 'defer';

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

    return $self->match_class->new(
        template => $self,
        gesture  => $gesture,
        score    => $raw_score,
    );
}

sub score_match {
    my $self     = shift;
    my $gesture  = shift;
    my $distance = $self->distance_at_best_angle($gesture);

    my $score = 1 - $distance / (.5 * sqrt(100 ** 2 + 100 ** 2));
    return $score * 100;
}

# these are specified in radians
use constant minimum_angle   => -0.785398163; # -45 degrees
use constant maximum_angle   =>  0.785398163; # 45 degrees
use constant angle_threshold => 0.034906585;  # 2 degrees

sub distance_at_best_angle {
    my $self    = shift;
    my $gesture = shift;

    my $minimum = $self->minimum_angle;
    my $maximum = $self->maximum_angle;
    my $threshold = $self->angle_threshold;

    my $phi = 1.61803399; # golden ratio

    my $x1 = defer {      $phi  * $minimum + (1 - $phi) * $maximum };
    my $x2 = defer { (1 - $phi) * $minimum +      $phi  * $maximum };

    my $f1 = defer { $self->distance_at_angle($gesture, $x1) };
    my $f2 = defer { $self->distance_at_angle($gesture, $x2) };

    while (abs($maximum - $minimum) > $threshold) {
        if ($f1 < $f2) {
            $maximum = 0 + $x2;
        }
        else {
            $minimum = 0 + $x1;
        }
    }

    return $f1 < $f2 ? $f1 : $f2;
}

sub distance_at_angle {
    my $self    = shift;
    my $gesture = shift;
    my $theta   = shift;

    my $rotated = $gesture->rotate_by($gesture->points, $theta);
    return $self->path_distance($rotated);
}

sub path_distance {
    my $self   = shift;
    my $points = shift;
    my $template = $self->points;

    my $distance = 0;

    for (my $i = 0; $i < @$template; ++$i) {
        my $d = $self->distance($template->[$i], $points->[$i]);
        $distance += $d;
    }

    $distance /= @$template;

    return $distance;
}

__PACKAGE__->meta->make_immutable;
no Any::Moose;

1;

