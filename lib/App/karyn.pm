package App::karyn;

use App::Cmd::Setup -app;
use Mojo::Base -base;
use Mojo::Client;
use Net::Riak;

use lib '/Users/glen/Projects/riak-tiny/Riak-Tiny/lib';
use Riak::Tiny;

has host => 'http://127.0.0.1:8098';
has riak => sub { Net::Riak->new(host => shift->host) };
has tiny => sub { Riak::Tiny->new(host => shift->host) };
has client => sub { Mojo::Client->new };

1;
