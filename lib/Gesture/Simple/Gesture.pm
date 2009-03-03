package Gesture::Simple::Gesture;
use Any::Moose;

has points => (
    is       => 'ro',
    isa      => 'ArrayRef',
    required => 1,
);

use constant resample_point_count => 64;

sub resample {
    my $self   = shift;
    my @points = @{ shift || $self->points };
    my @new_points = $points[0];

    my $I = $self->path_length(\@points) / ($self->resample_point_count - 1);
    my $D = 0;

    for (my $i = 1; $i < @points; ++$i) {
        my ($a, $b) = @points[$i-1, $i];
        my $d = $self->distance($a, $b);

        if ($D + $d > $I) {
            my $q_x = $a->[0] + (($I - $D) / $d) * ($b->[0] - $a->[0]);
            my $q_y = $a->[1] + (($I - $D) / $d) * ($b->[1] - $a->[1]);
            my $q = [$q_x, $q_y];

            push @new_points, $q;
            splice @points, $i, 0, $q;
            $D = 0;
        }
        else {
            $D += $d;
        }
    }

    return \@new_points;
}

sub path_length {
    my $self   = shift;
    my $points = shift;

    my $length = 0;
    for my $i (1 .. @$points - 1) {
        my ($a, $b) = @{$points}[$i-1, $i];
        $length += $self->distance($a, $b);
    }

    return $length;
}

sub distance {
    my (undef, $a, $b) = @_;
    return sqrt( ($a->[0] - $b->[0]) ** 2 + ($a->[1] - $b->[1]) ** 2 );
}

sub centroid {
    my $self   = shift;
    my $points = shift;

    my ($X, $Y) = (0, 0);

    for my $point (@$points) {
        $X += $point->[0];
        $Y += $point->[1];
    }

    return [ $X / @$points, $Y / @$points ];
}

sub rotate_to_zero {
    my $self   = shift;
    my $points = shift;

    my $c = $self->centroid($points);
    my $theta = atan2($c->[1] - $points->[0][1], $c->[0] - $points->[0][0]);

    return [ map { $self->rotate_by($c, $_, -$theta) } @$points ];
}

sub rotate_by {
    my $self   = shift;
    my $c      = shift;
    my $point  = shift;
    my $theta  = shift;

    my $x = ($point->[0] - $c->[0]) * cos($theta)
          - ($point->[1] - $c->[1]) * sin($theta)
          + $c->[0];

    my $y = ($point->[0] - $c->[0]) * sin($theta)
          + ($point->[1] - $c->[1]) * cos($theta)
          + $c->[1];

    return [$x, $y];
}

__PACKAGE__->meta->make_immutable;
no Any::Moose;

1;

