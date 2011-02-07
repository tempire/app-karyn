package App::karyn::Command::List;

use App::karyn -command;

use Modern::Perl;
use Devel::Dwarn;
use Term::ANSIColor;
use Data::Dump 'pp';

sub opt_spec {
    return (
        ['bucket|b=s' => 'Regex for bucket names', {default => '_'}],
        ['key|k=s'    => 'Regex for key name',     {default => '_'}],
        ['delete|d'   => 'Delete found keys'],
        ['links|l'    => 'List links in found keys'],
    );
}

sub abstract   {'List buckets and key/values'}
sub usage_desc {'karyn list --bucket name --key name'}

sub validate_args {
    my ($self, $opt, $args) = @_;

    $self->usage_error('Bucket and/or key required')
      if !$opt->bucket
          and !$opt->key;
}

sub execute {
    my ($self, $opt, $args) = @_;
    my $bucket = $opt->bucket;
    my $key    = $opt->key;

    my $tiny = $self->app->tiny;

    if (    $bucket eq '_'
        and $key eq '_'
        and @$args
        and $args->[0] =~ /(.+)?\/(.+)$/)
    {
        $bucket = $1;
        $key    = $2;
    }

    # Show key value
    if ($bucket ne '_' and $key ne '_') {
        my $obj = $tiny->get($bucket => $key);
        my $code = $obj ? $obj->tx->res->code : $@;
        print "$code (Error)\n" if $code != 200;

        print $obj->value . "\n";
    }

    # List buckets
    elsif ($bucket eq '_' and $key eq '_') {
        my @buckets = $tiny->buckets;
        print join("\n", @buckets) . "\n";
    }

    # List keys in bucket
    elsif ($bucket ne '_') {
        my @keys = $tiny->get($bucket)->keys;
        print join("\n", @keys) . "\n";
    }

    # Search all buckets for key
    elsif ($bucket eq '_' and $key ne '_') {

        # Clean up terminal color on CTRL+C
        $SIG{INT} = sub { print color 'reset', exit };

        for my $ibucket ($tiny->buckets) {
            print colored "$ibucket\n", 'blue';

            for my $ikey ($tiny->get($ibucket)->keys) {
                if ($key eq $ikey) {
                    print "/$key\n"
                      . $tiny->get($ibucket => $ikey)->value . "\n";
                }
            }
        }
    }
}

1;
