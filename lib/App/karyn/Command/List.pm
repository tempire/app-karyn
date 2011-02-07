package App::karyn::Command::List;

use App::karyn -command;

use Modern::Perl;
use Devel::Dwarn;
use Data::Dump 'pp';

sub opt_spec {
    return (
        ['bucket|b=s' => 'Regex for bucket names', {default => '_'}],
        ['key|k=s'    => 'Regex for key name'],
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

    my $tiny = $self->app->tiny;

    # Show key value
    if ($opt->bucket and $opt->key) {
        my $obj = $tiny->get($opt->bucket => $opt->key);
        my $code = $obj ? $obj->tx->res->code : $@;
        print "$code (Error)\n" if $code != 200;

        print $obj->value . "\n";
    }

    # List buckets
    elsif ($opt->bucket eq '_') {
        my @buckets = $tiny->buckets;
        print join("\n", @buckets) . "\n";
    }

    # List keys in bucket
    elsif ($opt->bucket eq '_') {
        my @keys = $tiny->get($opt->bucket)->keys;
        print join("\n", @keys) . "\n";
    }
}

1;
