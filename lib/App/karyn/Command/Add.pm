package App::karyn::Command::Add;

use App::karyn -command;

use Modern::Perl;
use Devel::Dwarn;

sub opt_spec {
    return (
        ['bucket|b=s' => 'Bucket name', {default => '_'}],
        ['key|k=s'    => 'Key name',    {default => '_'}],
        ['value|v=s'  => 'Key value',   {default => '_'}]
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
    my $bucket = $opt->bucket;
    my $key    = $opt->key;
    my $value  = $opt->value;

    my $tiny = $self->app->tiny;

    if (    $bucket eq '_'
        and $key eq '_'
        and @$args
        and $args->[0] =~ /(.+)?\/(.+)$/)
    {
        $bucket = $1;
        $key    = $2;
    }

    $value = $args->[1] if @$args and $args->[1];

    my $obj = $tiny->new_object($bucket => $key => $value);
    my $code = $obj ? $obj->client->tx->res->code : $@;
    print "$code No Content (Success)\n" if $code == 204;
}

1;

=head1 NAME

App::karyn::Command::Add

=head1 DESCRIPTION

Adds key/values to Riak

=head1 USAGE

See L<App::karyn>

=head1 METHODS

See L<App::Cmd>

=cut
