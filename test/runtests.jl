using ANSIEscapes
using Base.Terminals
using Test

const AE = ANSIEscapes

if !ispath("/dev/tty")
    # There is no terminal, we need to skip this test
    println("Skipping Device status repport test")
else
    @testset "Device status repport" begin
        write(stdout, AE.hide_cursor())
    
        write(stdout, AE.SCP())
        row1, col1 = AE.read_DSR()
    
        write(stdout, AE.CUP(1, 1))
        row, col = AE.read_DSR()
        @test (row, col) == (1, 1)
    
        nrows, ncols = AE.read_window_size()
        write(stdout, AE.CUP(nrows, ncols))
        row, col = AE.read_DSR()
        @test (row, col) == (nrows, ncols)
    
        write(stdout, AE.RCP())
        row, col = AE.read_DSR()
        @test (row, col) == (row1, col1)
    
        write(stdout, AE.show_cursor())
        flush(stdout)
    end
end
