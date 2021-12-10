	component unsaved is
		port (
			avalon_composant_0_conduit_end_in_freq_anemo : in  std_logic                    := 'X'; -- in_freq_anemo
			clk_clk                                      : in  std_logic                    := 'X'; -- clk
			pio_0_external_connection_export             : out std_logic_vector(7 downto 0);        -- export
			reset_reset_n                                : in  std_logic                    := 'X'  -- reset_n
		);
	end component unsaved;

	u0 : component unsaved
		port map (
			avalon_composant_0_conduit_end_in_freq_anemo => CONNECTED_TO_avalon_composant_0_conduit_end_in_freq_anemo, -- avalon_composant_0_conduit_end.in_freq_anemo
			clk_clk                                      => CONNECTED_TO_clk_clk,                                      --                            clk.clk
			pio_0_external_connection_export             => CONNECTED_TO_pio_0_external_connection_export,             --      pio_0_external_connection.export
			reset_reset_n                                => CONNECTED_TO_reset_reset_n                                 --                          reset.reset_n
		);

