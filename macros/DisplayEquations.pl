############################################
##	AUTHOR: Mitchell Sulz-Martin 		  ##
##	CONTACT: mitchell.sulzmartin@uleth.ca ##
##	VERSION: 1.0						  ##
##	LAST-EDIT: June 27/2018				  ##
##	DESCRIPTION: Displays a system of	  ##
##		equations, derived from a 		  ##
##		left- and right-hand matrix with  ##
## 		user-defined variable labels.	  ##
############################################

# --- EXAMPLE USAGE ---
# INPUT:
#	$mLHS = Matrix([ [3, 2, 1], [4, 5, 6]]);
#	$mRHS = Matrix([ [7, 8, 9], [-3, 2, -1]);
#	$cLHS = List(3, 1);
#	$cRHS = List(1, 4);
#	$vLHS = "x,y,_";
#	$vRHS = "x^2,_,y";
#
# OUTPUT:
#	3 (3x + 2y + 1) = 7x^2    + 8 + 9y
#	   4x + 5y + 6  = 4(-3x^2 + 2 - y)
###########################################################################################################################################
# Parameters:
#	mLHS: Matrix (MathObject) containing values for left-hand side of equations
#	mRHS: Matrix (MathObject) containing values for right-hand side of equations
#	cLHS: List (MathObject) contains values to multiply left-hand side by. 
#	cRHS: List (MathObject) contains values to multiply right-hand side by.
#	vLHS: (OPTIONAL) String, separated by commas with no spaces, for left-hand side variables. Using an underscore to represent no variable.
#	vRHS: (OPTIONAL) String, separated by commas with no spaces, for right-hand side variables. Using an underscore to represent no variable.

sub displayEquations{
	# --- VARS ---
    my $mLHS = shift;
    my $mRHS = shift;	
	my $cLHS = shift;	
    my $cRHS = shift;	
    my $vLHS = shift;	
    my $vRHS = shift;	
	@dimL = $mLHS->dimensions;
	@dimR = $mRHS->dimensions;

	# --- LATEX INITIALIZATION ---
	my $dataStr = "\\[ \\begin{array}{";
	for (my $i = 0; $i <= ($dimL[1] + $dimR[1]); $i++){ $dataStr = $dataStr."r"; }
    $dataStr = $dataStr."}";
	
	# --- LHS & RHS PROCESSING ---
	for (my $i = 0; $i < $dimL[0]; $i++)
    {	  
        $dataLHS = processRow($mLHS, $vLHS, $i+1);
		$dataRHS = processRow($mRHS, $vRHS, $i+1);
		if ($cLHS->extract($i+1) != 1) {$dataLHS = $cLHS->extract($i+1)." ( ".$dataLHS." ) ";}
		if ($cRHS->extract($i+1) != 1) {$dataRHS = $cRHS->extract($i+1)." ( ".$dataRHS." ) ";}
		if ($i == max($dimL[0], $dimR[0]) - 1){ $dataStr = $dataStr.$dataLHS."& = &".$dataRHS; }
		else { $dataStr = $dataStr.$dataLHS."& = &".$dataRHS."\\\\"; }
	}
	$dataStr = $dataStr."\\end{array}.\\]";
	return $dataStr;
}

sub processRow{
    # --- VARS ---
    my $M = shift;
	my $varStr = shift;
    my $currRow = shift;
    my $data;
    my $nonzero = 0;
	@dim = $M->dimensions;
    my @var = split(",",$varStr);
	
	for (my $j = 0; $j < $dim[1]; $j++){
		my $elmt = $M->element($currRow,$j+1);
		if($j == 0){
			if ($var[$j] ne "_"){
				if ($elmt == 1) {$data = $data.$var[$j]; $nonzero = 1;}
				elsif ($elmt == -1) {$data = $data."-".$var[$j]; $nonzero = 1;}
				elsif ($elmt != 0) {$data = $data.$elmt.$var[$j]; $nonzero = 1;}
				else {$data = $data."& &";}
                }
			else{
				if ($elmt == 1) {$data = $data."1";}
				elsif ($elmt == -1) {$data = $data."-1";}
				elsif ($elmt != 0) {$data = $data.$elmt;}
				else {$data = $data."& &";}}}
		else{
			$sign = ($elmt > 0) ? "+" : "-";
			$sign = ($elmt > 0 && $nonzero == 0)? "" : $sign;
			if ($elmt == 0) {$data = $data;}
			elsif ($var[$j] ne "_"){
				if (abs($elmt) == 1 && $nonzero) {$data = $data."&".$sign."&".$var[$j];}
				elsif ($nonzero){$absElmt = abs($elmt); $data = $data."&".$sign."&".$absElmt.$var[$j];}
				else {$data = $data."&".$elmt.$var[$j];}}
			else{
				if (abs($elmt) == 1 && $nonzero) {$data = $data."&".$sign."&1";}
				elsif ($nonzero){$absElmt = abs($elmt); $data = $data."&".$sign."&".$absElmt;}
				else {$data = $data."&".$elmt;}
				$nonzero = 1;}}}
	return $data;
	}