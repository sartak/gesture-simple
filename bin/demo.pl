#!/usr/bin/env perl
use strict;
use warnings;
use Gesture::Simple;

# For some reason, SDL spews all kinds of garbage on my screen :/
BEGIN {
    close STDERR;
    $SIG{__WARN__} = sub { print @_ };
    $SIG{__DIE__} = sub { print @_; die @_ };
}

package Gesture::Simple::Demo::App;
use strict;
use warnings;
use SDL::App::FPS 'BUTTON_MOUSE_LEFT';
use SDL;
use SDL::Rect;
use base 'SDL::App::FPS';

sub draw_frame {
    my $self = shift;

    if ($self->is_gesturing) {
        for my $point (@{ $self->{gesture} }) {
            my ($x, $y) = @$point;

            my $rect = SDL::Rect->new(
                -height => 1,
                -width  => 1,
                -x      => $x,
                -y      => $y,
            );

            my $green = SDL::Color->new(
                -r => 0,
                -g => 0xFF,
                -b => 0,
            );

            $self->app->fill($rect, $green);
        }
    }

    my $screen_rect = SDL::Rect->new(
        -height => $self->height,
        -width  => $self->width,
        -x      => 0,
        -y      => 0,
    );

    $self->app->update($screen_rect);
}

sub is_gesturing {
    my $self = shift;
    $self->{is_gesturing};
}

sub begin_gesture {
    my $self = shift;
    $self->{gesture} = [];
    $self->{is_gesturing} = 1;

    my $screen_rect = SDL::Rect->new(
        -height => $self->height,
        -width  => $self->width,
        -x      => 0,
        -y      => 0,
    );

    my $black = SDL::Color->new(
        -r => 0,
        -g => 0,
        -b => 0,
    );

    $self->app->fill($screen_rect, $black);
}

sub update_gesture {
    my $self = shift;
    return unless $self->is_gesturing;

    push @{ $self->{gesture} }, [@_];
}

sub end_gesture {
    my $self = shift;

    $self->{is_gesturing} = 0;

    my $gesture = $self->{gesture};


    my @matches = $self->{gesture_recognizer}->match($gesture);
}

sub post_init_handler {
    my $self = shift;

    $self->{gesture_recognizer} = Gesture::Simple->new;

    $self->add_event_handler(SDL_KEYDOWN, SDLK_q, sub {
        my $self = shift;
        $self->quit;
    });

    $self->add_event_handler(SDL_MOUSEBUTTONDOWN, BUTTON_MOUSE_LEFT, sub {
        my $self = shift;
        $self->begin_gesture;
    });

    $self->add_event_handler(SDL_MOUSEBUTTONUP, BUTTON_MOUSE_LEFT, sub {
        my $self = shift;
        $self->end_gesture;
    });

    $self->add_event_handler(SDL_MOUSEMOTION, BUTTON_MOUSE_LEFT, sub {
        my ($self, $handler, $event) = @_;
        $self->update_gesture($event->motion_x, $event->motion_y);
    });
}


package main;

my $app = Gesture::Simple::Demo::App->new(
    width  => 320,
    height => 240,
    title  => 'Gesture::Simple demo',
);

$app->main_loop;

