#!/usr/bin/env perl
use strict;
use warnings;
use Gesture::Simple;
use Test::More tests => 6;

my $recognizer = Gesture::Simple->new;

my $line = Gesture::Simple::Template->new(
    name   => 'line',
    points => [
        [0, 0],
        [1, 1],
    ],
);

$recognizer->add_template($line);

my $gesture = Gesture::Simple::Gesture->new(
    points => [
        [0, 0],
        [1, 1],
    ],
);

my $match = $recognizer->match($gesture);

ok($match, 'got a match');
isa_ok($match, 'Gesture::Simple::Match', 'match class');
is($match->template, $line, 'correct template');
is($match->name, 'line', 'correct match name');
is($match->gesture, $gesture, 'correct gesture');
cmp_ok($match->score, '>', 95, 'the gesture matched very well');

