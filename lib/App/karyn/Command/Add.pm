package App::karyn::Command::Add;

use App::karyn -command;

use Modern::Perl;
use Devel::Dwarn;
use Data::Dump 'pp';

sub opt_spec {
    return (
        ['bucket|b=s' => 'Bucket name'],
        ['key|k=s'    => 'Key name'],
        ['value|v=s'  => 'Key value']
    );
}

sub abstract   {'Add keys to buckets'}
sub usage_desc {'karyn add --bucket name --key name --value value'}

sub validate_args {
    my ($self, $opt, $args) = @_;

    $self->usage_error('Bucket, key, & value required')
      if !$opt->bucket
          and !$opt->key
          and !$opt->value;
}

sub execute {
    my ($self, $opt, $args) = @_;

    my $tiny = $self->app->tiny;

    my $obj = $tiny->new_object($opt->bucket => $opt->key => $opt->value);
    my $code = $obj ? $obj->tx->res->code : $@;
    print "$code No Content (Success)\n" if $code == 204;
}

1;
