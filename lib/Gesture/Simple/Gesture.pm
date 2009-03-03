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
    my @new_points;

    my $I = $self->path_length($points) / ($self->resample_point_count - 1);
    my $D = 0;

    for (my $i = 0; $i < @$points - 1; ++$i) {
        my ($a, $b) = @{$points}[$i, $i+1];
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
    for my $i (0 .. @$points - 2) {
        my ($a, $b) = @{$points}[$i, $i+1];
        $length += $self->distance($a, $b);
    }

    return $length;
}

sub distance {
    my (undef, $a, $b) = @_;
    return sqrt( ($a->[0] + $b->[0]) ** 2 + ($a->[1] + $b->[1]) ** 2 );
}

__PACKAGE__->meta->make_immutable;
no Any::Moose;

1;

