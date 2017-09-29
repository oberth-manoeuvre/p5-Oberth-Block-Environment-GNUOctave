use Oberth::Common::Setup;
package Oberth::Service::GNUOctave::Doc::Eval;
# ABSTRACT: Retrieves documentation via Octave command line

use Moo;
use Oberth::Common::Types qw(InstanceOf Str);

has octave_interpreter => (
	is => 'ro',
	isa => InstanceOf['Oberth::Service::GNUOctave::Interpreter'],
	required => 1,
);

method retrieve( (Str) $doc) {
	my $doc_escape = $doc =~ s/'/''/r; # double apostrophes to escape
	my ($stdout, $stderr, $exit) = $self->octave_interpreter->_eval( "help '$doc_escape'" );

	if( $stderr =~ /^error: help: .* not found/ ) {
		Oberth::Common::Error::Retrieval::NotFound->throw( $stdout );
	}

	return $stdout;
}

with qw(Oberth::Service::Role::DocumentRetrievable);

1;
