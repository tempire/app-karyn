package App::karyn;

use App::Cmd::Setup -app;
use Mojo::Base -base;
use Mojo::Client;
use Riak::Tiny;

has host => $ENV{RIAK_HOST} || 'http://127.0.0.1:8098';
has tiny => sub { Riak::Tiny->new(host => shift->host) };
has client => sub { Mojo::Client->new };

1;

=head1 NAME

App::karyn - Command line utility for perusing buckets and keys in Riak

=head1 DESCRIPTION

Command line utility for perusing buckets and keys in Riak

=head2 Why is it named Karyn?

Every Stargate SG1 fan who mispronounces "Riak" initially, should be able 
to answer this question.

=over 4

=item Rya'c is Teal'c's son.

=item Karyn is Rya'c's wife.

=item Karyn is a helper for Riak.

=back

=head1 USAGE


=head1 USAGE

Add a bucket, key, and value

    karyn add --bucket b --key k --value v
    karyn add b/k v

Show a key's value

    karyn list --bucket b --key k
    karyn list -b k -k k
    karyn list b/k

Show JSON value as perl structure

    karyn list --bucket b --key k --perl
    karyn list -b b -k k -p
    karyn list b/k -p

List all keys in bucket

    karyn list --bucket b
    karyn list b

Search all buckets for a key

    karyn list --bucket _ --key name
    karyn list --key name
    karyn list _/name

Delete key

    karyn delete --bucket b --key k
    karyn delete -b b -k k
    karyn delete b/k

Delete all keys in bucket

    karyn delete --bucket b
    karyn delete -b b -d

=cut
