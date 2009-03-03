#!/usr/bin/env perl
use strict;
use warnings;
use Gesture::Simple;
use Test::More tests => 6;

my $recognizer = Gesture::Simple->new;

my $template = Gesture::Simple::Template->new(
    name   => 'L',
    points => [
        [ 73,  58 ],
        [ 73,  59 ],
        [ 73,  61 ],
        [ 73,  63 ],
        [ 73,  68 ],
        [ 73,  74 ],
        [ 74,  82 ],
        [ 74,  88 ],
        [ 75,  94 ],
        [ 75, 102 ],
        [ 76, 109 ],
        [ 76, 118 ],
        [ 76, 124 ],
        [ 77, 129 ],
        [ 77, 131 ],
        [ 77, 135 ],
        [ 77, 136 ],
        [ 77, 138 ],
        [ 77, 140 ],
        [ 78, 141 ],
        [ 80, 141 ],
        [ 84, 141 ],
        [ 91, 142 ],
        [101, 142 ],
        [112, 142 ],
        [123, 142 ],
        [135, 141 ],
        [148, 140 ],
        [161, 140 ],
        [169, 139 ],
        [175, 138 ],
        [176, 138 ],
        [177, 138 ],
    ],
);

$recognizer->add_template($template);

my $gesture = Gesture::Simple::Gesture->new(
    points => [
        [  94,  64 ],
        [  94,  66 ],
        [  94,  71 ],
        [  95,  76 ],
        [  96,  86 ],
        [  97,  99 ],
        [  97, 109 ],
        [  98, 120 ],
        [ 100, 130 ],
        [ 103, 138 ],
        [ 105, 143 ],
        [ 109, 147 ],
        [ 113, 151 ],
        [ 134, 156 ],
        [ 155, 156 ],
        [ 186, 155 ],
        [ 206, 153 ],
        [ 219, 153 ],
        [ 223, 152 ],
        [ 230, 151 ],
        [ 234, 150 ],
        [ 236, 150 ],
    ],
);

use DDS; warn Dump($template->resample);

my $match = $recognizer->match($gesture);

ok($match, 'got a match');
isa_ok($match, 'Gesture::Simple::Match', 'match class');
is($match->template, $template, 'correct template');
is($match->name, 'L', 'correct match name');
is($match->gesture, $gesture, 'correct gesture');
cmp_ok($match->score, '>', 95, 'the gesture matched very well');

