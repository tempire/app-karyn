use Modern::Perl;
use Test::Most;

use App::Cmd::Tester;
use App::karyn;

# add key/value
is test_app('App::karyn' => [qw/add --bucket b1 --key k1 --value v1/])
  ->stdout => "204 No Content (Success)\n",
  'add key/value';

# list buckets
like test_app('App::karyn' => [qw/list --buckets/])->stdout => qr/\nhello\n/,
  'list buckets';

# list buckets alias
is test_app('App::karyn' => [qw/list/])->stdout =>
  test_app('App::karyn' => [qw/list --buckets/])->stdout,
  'default list buckets';

# show key value aliases
is test_app('App::karyn' => [qw/list --bucket b1 --key k1/])->stdout =>
  "v1\n";
is test_app('App::karyn' => [qw/list -b b1 -k k1/])->stdout => "v1\n";
is test_app('App::karyn' => [qw|list b1/k1|])->stdout       => "v1\n";

# Search all buckets for matching key
is test_app('App::karyn' => [qw|list --bucket _ --key k1|])->stdout =>
  "bucket/k1:\nv1\n";
is test_app('App::karyn' => [qw|list --key k1|])->stdout =>
  "bucket/k1:\nv1\n";

#
#
#is test_app('App::karyn' => [qw'add b2/k2 --value v2'])->stdout => "204 No Content (Success)\n";
#is test_app('App::karyn' => [qw'list b2/k2'])->stdout           => 'v2';

done_testing;
