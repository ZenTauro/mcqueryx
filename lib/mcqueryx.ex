# SPDX-License-Identifier: AGPL-3.0-or-later
#
# This library communicates with a Minecraft server through the query
# protocol.
#
# Copyright (C) 2020 Pedro Gomez Martin
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU Affero General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option) any
# later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License along
# with this program. If not, see <https://www.gnu.org/licenses/>.

defmodule MCQueryx do
  @moduledoc """
  A library to comunicate with a Minecraft server
  using the query protocol.
  """
  #use GenServer

  @magic <<254, 253>>
  @msg_type <<9>>
  @sid <<0,0,2,1>>

  @doc """
  Connects to the given server and returns the connection
  and challenge token
  ## Examples

      MCQueryx.connect("mc.hypixel.net", 25565)
      5871589

  """
  def connect(server, port) do
    address = {server, port}
    client = Socket.UDP.open!

    client
      |> Socket.Datagram.send!(@magic <> @msg_type <> @sid , address)

    { <<@msg_type <> @sid <> bitchallenge :: binary>>, {_, _} } =
      client |> Socket.Datagram.recv!

    #ls = to_char_list(bitchallenge)
      #|> Enum.map(fn a -> << a :: utf8 >> end)

    #sz = (length(ls) - 1) * 8
    #<< challenge :: size(sz), _ :: binary >> = bitchallenge

    { {client, address}, bitchallenge } #<<bitchallenge :: size(sz)>> }
  end

  @doc """
  Queries a server given a connection

      MCQueryx.connect("mc.hypixel.net", 25565)
        |> MCQueryx.query
  """
  def query({ {client, address}, token }) do
    client
      |> Socket.Datagram.send!(@magic <> <<0>> <> @sid <> token, address)
    client
      |> Socket.Datagram.recv!
  end
end
