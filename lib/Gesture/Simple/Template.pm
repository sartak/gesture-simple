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

    my $x1 =      $phi  * $minimum + (1 - $phi) * $maximum;
    my $x2 = (1 - $phi) * $minimum +      $phi  * $maximum;

    my $f1 = $self->distance_at_angle($gesture, $x1);
    my $f2 = $self->distance_at_angle($gesture, $x2);

    while ($maximum - $minimum > $threshold) {
        if ($f1 < $f2) {
            $maximum = $x2;
            $x2 = $x1;
            $f2 = $f1;
            $x1 = $phi * $minimum + (1 - $phi) * $maximum;
            $f1 = $self->distance_at_angle($gesture, $x1);
        }
        else {
            $minimum = $x1;
            $x1 = $x2;
            $f1 = $f2;
            $x2 = (1 - $phi) * $minimum + $phi * $maximum;
            $f2 = $self->distance_at_angle($gesture, $x2);
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

    my $d = 0;

    for (my $i = 0; $i < @$template; ++$i) {
        next unless $template->[$i] && $points->[$i];
        $d += $self->distance($template->[$i], $points->[$i]);
    }

    my $distance = $d / @$template;
    return $distance;
}

__PACKAGE__->meta->make_immutable;
no Any::Moose;

1;

