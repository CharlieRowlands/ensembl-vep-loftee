# Copyright [1999-2016] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#      http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

use strict;
use warnings;

use Test::More;
use Test::Exception;
use FindBin qw($Bin);

use lib $Bin;
use VEPTestingConfig;
my $test_cfg = VEPTestingConfig->new();

## BASIC TESTS
##############

# use test
use_ok('Bio::EnsEMBL::VEP::AnnotationSource::File::BED');

my $file = $test_cfg->{custom_bed};

my $as = Bio::EnsEMBL::VEP::AnnotationSource::File::BED->new({file => $file});
ok($as, 'new is defined');

# need to get a config object for further tests
use_ok('Bio::EnsEMBL::VEP::Config');

my $cfg = Bio::EnsEMBL::VEP::Config->new($test_cfg->base_testing_cfg);
ok($cfg, 'get new config object');



## TESTS WITH INPUT BUFFER
##########################

use_ok('Bio::EnsEMBL::VEP::Parser::VCF');
my $p = Bio::EnsEMBL::VEP::Parser::VCF->new({
  config => $cfg,
  file => $test_cfg->create_input_file([qw(21 25585733 rs142513484 C T . . .)]),
  valid_chromosomes => [21]
});
ok($p, 'get parser object');

use_ok('Bio::EnsEMBL::VEP::InputBuffer');
my $ib = Bio::EnsEMBL::VEP::InputBuffer->new({config => $cfg, parser => $p});
is(ref($ib), 'Bio::EnsEMBL::VEP::InputBuffer', 'check class');

is(ref($ib->next()), 'ARRAY', 'check buffer next');

# $as->annotate_InputBuffer($ib);

# is_deeply(
#   $ib->buffer->[0]->{_custom_annotations},
#   {
#     'test.bed.gz' => [
#       { name => 'test1' },
#       { name => 'test2' }
#     ]
#   },
#   'annotate_InputBuffer - overlap'
# );

# # exact type
# $as->type('exact');
# $as->short_name('foo');
# $as->annotate_InputBuffer($ib);

# is_deeply(
#   $ib->buffer->[0]->{_custom_annotations},
#   {

#     'test.bed.gz' => [
#       { name => 'test1' },
#       { name => 'test2' }
#     ],
#     'foo' => [
#       { name => 'test2' }
#     ]
#   },
#   'annotate_InputBuffer - exact, additive'
# );

# # out by one
# delete($ib->buffer->[0]->{_custom_annotations});

# $ib = Bio::EnsEMBL::VEP::InputBuffer->new({
#   config => $cfg,
#   parser => Bio::EnsEMBL::VEP::Parser::VCF->new({
#     config => $cfg,
#     file => $test_cfg->create_input_file([qw(21 25585732 rs142513484 C T . . .)]),
#     valid_chromosomes => [21]
#   })
# });
# $ib->next();

# $as->annotate_InputBuffer($ib);
# ok(!$ib->buffer->[0]->{_custom_annotations}, 'annotate_InputBuffer - out by 1 (5\')');



# $ib = Bio::EnsEMBL::VEP::InputBuffer->new({
#   config => $cfg,
#   parser => Bio::EnsEMBL::VEP::Parser::VCF->new({
#     config => $cfg,
#     file => $test_cfg->create_input_file([qw(21 25585735 rs142513484 C T . . .)]),
#     valid_chromosomes => [21]
#   })
# });
# $ib->next();

# $as->annotate_InputBuffer($ib);
# ok(!$ib->buffer->[0]->{_custom_annotations}, 'annotate_InputBuffer - out by 1 (3\')');


done_testing();