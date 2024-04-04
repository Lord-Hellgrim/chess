package chess

import rl "vendor:raylib"
import fmt "core:fmt"


Side :: enum {
    None,
    White,
    Black,
}

PieceType :: enum {
    None,
    Pawn,
    Knight,
    Bishop,
    Rook,
    King,
    Queen,
}


Piece :: struct {
    type: PieceType,
    owner: Side,
    moved: bool,
}

Tile :: struct {
    selected: bool,
    can_move: bool,
    piece: Piece,
    x: int,
    y: int,
}


GameState :: struct {
    board: [8][8]Tile,
    player1_id: string,
    player2_id: string,
    whos_turn: Side,
}


init_board :: proc() -> [8][8]Tile {
    
    board :[8][8]Tile;
    
    for i in 0..<8 {
        for j in 0..<8 {

            if j == 0 {
                if i == 0 || i == 7 {
                    board[i][j] = Tile {
                        selected = false,
                        piece = Piece {
                            type = PieceType.Rook,
                            owner = Side.Black,
                        },
                    }
                }
                else if i == 1 || i == 6 {
                    board[i][j] = Tile {
                        selected = false,
                        piece = Piece {
                            type = PieceType.Knight,
                            owner = Side.Black,
                        },
                    }
                } else if i == 2 || i == 5 {
                    board[i][j] = Tile {
                        selected = false,
                        piece = Piece {
                            type = PieceType.Bishop,
                            owner = Side.Black,
                        },
                    }
                } else if i == 3{
                    board[i][j] = Tile {
                        selected = false,
                        piece = Piece {
                            type = PieceType.King,
                            owner = Side.Black,
                        },
                    }
                } else if i == 4 {
                    board[i][j] = Tile {
                        selected = false,
                        piece = Piece {
                            type = PieceType.Queen,
                            owner = Side.Black,
                        },
                    }
                }
            }

            // if j == 1 {
            //     board[i][j] = Tile {
            //         selected = false,
            //         piece = Piece {
            //             type = PieceType.Pawn,
            //             owner = Side.Black,
            //         },
            //     }
            // }

            if j == 7 {
                if i == 0 || i == 7 {
                    board[i][j] = Tile {
                        selected = false,
                        piece = Piece {
                            type = PieceType.Rook,
                            owner = Side.White,
                        },
                    }
                }
                else if i == 1 || i == 6 {
                    board[i][j] = Tile {
                        selected = false,
                        piece = Piece {
                            type = PieceType.Knight,
                            owner = Side.White,
                        },
                    }
                } else if i == 2 || i == 5 {
                    board[i][j] = Tile {
                        selected = false,
                        piece = Piece {
                            type = PieceType.Bishop,
                            owner = Side.White,
                        },
                    }
                } else if i == 3{
                    board[i][j] = Tile {
                        selected = false,
                        piece = Piece {
                            type = PieceType.King,
                            owner = Side.White,
                        },
                    }
                } else if i == 4 {
                    board[i][j] = Tile {
                        selected = false,
                        piece = Piece {
                            type = PieceType.Queen,
                            owner = Side.White,
                        },
                    }
                }
            }

            // if j == 6 {
            //     board[i][j] = Tile {
            //         selected = false,
            //         piece = Piece {
            //             type = PieceType.Pawn,
            //             owner = Side.White,
            //         },
            //     }
            // }

        }
    }

    for i in 0..<8 {
        for j in 0..<8 {
            board[i][j].x = i;
            board[i][j].y = j;
        }
    }

    return board
}

cell_width :f32 : 64;
cell_height :f32 : 64;

PAWN :[16][16]u8 : {
    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0},
    {0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0},
    {0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0},
    {0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0},
    {0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0},
    {0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0},
    {0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0},
    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
};

ROOK :[16][16]u8 : {
    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    {0,0,0,1,0,1,0,1,0,1,0,1,0,0,0,0},
    {0,0,0,1,1,1,1,1,1,1,1,1,0,0,0,0},
    {0,0,0,1,1,1,1,1,1,1,1,1,0,0,0,0},
    {0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0},
    {0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0},
    {0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0},
    {0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0},
    {0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0},
    {0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0},
    {0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0},
    {0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0},
    {0,0,0,1,1,1,1,1,1,1,1,1,0,0,0,0},
    {0,0,0,1,1,1,1,1,1,1,1,1,0,0,0,0},
    {0,0,0,1,1,1,1,1,1,1,1,1,0,0,0,0},
    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
};

KNIGHT :[16][16]u8 : {
    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    {0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0},
    {0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0},
    {0,0,0,1,1,1,1,1,1,1,1,1,0,0,0,0},
    {0,0,0,1,1,1,1,1,1,1,1,1,0,0,0,0},
    {0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,0},
    {0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0},
    {0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0},
    {0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0},
    {0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0},
    {0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0},
    {0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0},
    {0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,0},
    {0,0,1,1,1,1,1,1,1,1,1,1,0,0,0,0},
    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
};

BISHOP :[16][16]u8 : {
    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0},
    {0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0},
    {0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0},
    {0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0},
    {0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0},
    {0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0},
    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
};

KING :[16][16]u8 : {
    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    {0,1,0,0,0,1,0,0,0,1,0,0,0,1,0,0},
    {0,1,1,0,1,1,1,0,1,1,1,0,1,1,0,0},
    {0,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0},
    {0,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0},
    {0,0,0,1,1,1,1,1,1,1,1,1,0,0,0,0},
    {0,0,0,1,1,1,1,1,1,1,1,1,0,0,0,0},
    {0,0,0,1,1,1,1,1,1,1,1,1,0,0,0,0},
    {0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0},
    {0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0},
    {0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0},
    {0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0},
    {0,0,0,1,1,1,1,1,1,1,1,1,0,0,0,0},
    {0,0,1,1,1,1,1,1,1,1,1,1,1,0,0,0},
    {0,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0},
    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
};

QUEEN :[16][16]u8 : {
    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0},
    {0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0},
    {0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0},
    {0,0,0,0,1,1,0,1,1,0,1,1,0,0,0,0},
    {0,0,1,1,1,0,0,1,1,0,0,1,1,1,0,0},
    {0,0,0,1,1,1,0,1,1,0,1,1,1,0,0,0},
    {0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0},
    {0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0},
    {0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0},
    {0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0},
    {0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0},
    {0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0},
    {0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0},
    {0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0},
    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
};

LIGHTGREEN : rl.Color : {
    150,
    255,
    150,
    255, 
};

draw_piece :: proc(i: int, j: int, owner: Side, shape: [16][16]u8) {
    
    color: rl.Color;
    if owner == Side.Black {
        color = rl.BLACK;
    } else {
        color = rl.WHITE;
    }

    for x in 0..<16 {
        for y in 0..<16 {
            if shape[y][x] == 1 {
                rect := rl.Rectangle{
                    x      = f32(i+x) * 4,
                    y      = f32(j+y) * 4,
                    width  = 4,
                    height = 4,
                }
                rl.DrawRectangleRec(rect, color);
            }
        }
    }
}


render_board :: proc(game_state: ^GameState, color: rl.Color) {
    
    for i in 0..<8 {
        for j in 0..<8 {
            if (i + j)%2 == 0{
                rect := rl.Rectangle{
                    x      = f32(i) * cell_width,
                    y      = f32(j) * cell_height,
                    width  = cell_width-5,
                    height = cell_height-5,
                }
                rl.DrawRectangleRec(rect, color);
            } else {
                rect := rl.Rectangle{
                    x      = f32(i) * cell_width,
                    y      = f32(j) * cell_height,
                    width  = cell_width-5,
                    height = cell_height-5,
                }
                rl.DrawRectangleRec(rect, rl.DARKGRAY);
            }

            if game_state.board[i][j].selected{
                rect := rl.Rectangle{
                    x      = f32(i) * cell_width,
                    y      = f32(j) * cell_height,
                    width  = cell_width-5,
                    height = cell_height-5,
                }
                rl.DrawRectangleRec(rect, rl.GREEN);
            } else if game_state.board[i][j].can_move {
                rect := rl.Rectangle{
                    x      = f32(i) * cell_width,
                    y      = f32(j) * cell_height,
                    width  = cell_width-5,
                    height = cell_height-5,
                }
                rl.DrawRectangleRec(rect, LIGHTGREEN);
            }

        }
    }

    for i in 0..<8 {
        for j in 0..<8 {
            if game_state.board[i][j].piece.type == PieceType.Pawn {
                draw_piece(i*16, j*16, game_state.board[i][j].piece.owner, PAWN);
            } else if game_state.board[i][j].piece.type == PieceType.Rook {
                draw_piece(i*16, j*16, game_state.board[i][j].piece.owner, ROOK);
            } else if game_state.board[i][j].piece.type == PieceType.Knight {
                draw_piece(i*16, j*16, game_state.board[i][j].piece.owner, KNIGHT);
            } else if game_state.board[i][j].piece.type == PieceType.Bishop {
                draw_piece(i*16, j*16, game_state.board[i][j].piece.owner, BISHOP);
            } else if game_state.board[i][j].piece.type == PieceType.King {
                draw_piece(i*16, j*16, game_state.board[i][j].piece.owner, KING);
            } else if game_state.board[i][j].piece.type == PieceType.Queen {
                draw_piece(i*16, j*16, game_state.board[i][j].piece.owner, QUEEN);
            }
        }
    }
}


User_Input :: struct {
    left_mouse_clicked:   bool,
    right_mouse_clicked:  bool,
    commit_action:        bool,
    mouse_world_position: i32,
    mouse_tile_x:         i32,
    mouse_tile_y:         i32,
}

process_user_input :: proc(user_input: ^User_Input) {
    m_pos := rl.GetMousePosition()
    mouse_x := i32(m_pos[0]);
    mouse_y := i32(m_pos[1]);

    user_input^ = User_Input{
        left_mouse_clicked    = rl.IsMouseButtonReleased(.LEFT),
        right_mouse_clicked   = rl.IsMouseButtonReleased(.RIGHT),
        commit_action         = rl.IsKeyReleased(.ENTER),
        mouse_world_position  = i32(mouse_y * 1024 + mouse_x),
        mouse_tile_x          = mouse_x,
        mouse_tile_y          = mouse_y,
    }
}

sum8 :: proc(x: int, y: int) -> int {
    if x + y > 7 {
        return x
    } else {
        return x + y
    }
}

diff8 :: proc(x: int, y: int) -> int {
    if x - y < 0 {
        return x
    } else {
        return x - y
    }
}

set_can_move :: proc(game: ^GameState, x: int, y: int) -> bool{
    if !((x > 7) | (y > 7) | (x < 0) | (y < 0)) {   
        game.board[x][y].can_move ~= true;
        return true;
    } else {
        return false;
    }
} 

show_bishop_moves :: proc(game: ^GameState, selected_tile: ^Tile) {
    current_x := selected_tile.x;
    current_y := selected_tile.y;
    for current_x > 0 && current_y > 0 {
        current_x -= 1;
        current_y -= 1;
        if game.board[current_x][current_y].piece.type != .None {
            if game.board[current_x][current_y].piece.owner != selected_tile.piece.owner {
                game.board[current_x][current_y].can_move = true;
                break;
            } else {break}
        } else {
            game.board[current_x][current_y].can_move = true;
        }
    }
    current_x = selected_tile.x;
    current_y = selected_tile.y;
    for current_x < 7 && current_y > 0 {
        current_x += 1;
        current_y -= 1;
        if game.board[current_x][current_y].piece.type != .None {
            if game.board[current_x][current_y].piece.owner != selected_tile.piece.owner {
                game.board[current_x][current_y].can_move = true;
                break;
            } else {break}
        } else {
            game.board[current_x][current_y].can_move = true;
        }
    }
    current_x = selected_tile.x;
    current_y = selected_tile.y;
    for current_x > 0 && current_y < 7 {
        current_x -= 1;
        current_y += 1;
        if game.board[current_x][current_y].piece.type != .None {
            if game.board[current_x][current_y].piece.owner != selected_tile.piece.owner {
                game.board[current_x][current_y].can_move = true;
                break;
            } else {break}
        } else {
            game.board[current_x][current_y].can_move = true;
        }
    }
    current_x = selected_tile.x;
    current_y = selected_tile.y;
    for current_x < 7 && current_y < 7 {
        current_x += 1;
        current_y += 1;
        if game.board[current_x][current_y].piece.type != .None {
            if game.board[current_x][current_y].piece.owner != selected_tile.piece.owner {
                game.board[current_x][current_y].can_move = true;
                break;
            } else {break}
        } else {
            game.board[current_x][current_y].can_move = true;
        }
    }
}

show_rook_moves :: proc(game: ^GameState, selected_tile: ^Tile) {

    current_x := selected_tile.x;
    current_y := selected_tile.y;
    for current_x > 0 {
        current_x -= 1;
        if game.board[current_x][current_y].piece.type != .None {
            if game.board[current_x][current_y].piece.owner != selected_tile.piece.owner {
                game.board[current_x][current_y].can_move = true;
                break;
            } else {break}
        }
        game.board[current_x][current_y].can_move = true;
    }

    current_x = selected_tile.x;
    current_y = selected_tile.y;
    for current_x < 7 {
        current_x += 1;
        if game.board[current_x][current_y].piece.type != .None {
            if game.board[current_x][current_y].piece.owner != selected_tile.piece.owner {
                game.board[current_x][current_y].can_move = true;
                break;
            } else {break}
        }
        game.board[current_x][current_y].can_move = true;
    }

    current_x = selected_tile.x;
    current_y = selected_tile.y;
    for current_y > 0 {
        current_y -= 1;
        if game.board[current_x][current_y].piece.type != .None {
            if game.board[current_x][current_y].piece.owner != selected_tile.piece.owner {
                game.board[current_x][current_y].can_move = true;
                break;
            } else {break}
        }
        game.board[current_x][current_y].can_move = true;
    }

    current_x = selected_tile.x;
    current_y = selected_tile.y;
    for current_y < 7 {
        current_y += 1;
        if game.board[current_x][current_y].piece.type != .None {
            if game.board[current_x][current_y].piece.owner != selected_tile.piece.owner {
                game.board[current_x][current_y].can_move = true;
                break;
            } else {break}
        }
        game.board[current_x][current_y].can_move = true;
    }
}

main::proc() {

    Board := init_board();

    game := GameState {
        board = Board,
        player1_id = "one",
        player2_id = "two",
        whos_turn = Side.White,
    }

    user_input: User_Input;

    rl.InitWindow(512, 512, "test");
    rl.SetWindowState( rl.ConfigFlags{} );
    rl.SetTargetFPS(60);

    selected_tile: Tile;
    last_selected_tile: Tile;

    for !rl.WindowShouldClose() {

        process_user_input(&user_input);
        if user_input.left_mouse_clicked {
            tile_x := user_input.mouse_tile_x/64;
            tile_y := user_input.mouse_tile_y/64;
            if game.board[tile_x][tile_y].selected {
                game.board[tile_x][tile_y].selected = false;
                selected_tile = game.board[tile_x][tile_y];

            } else {
                
                for i in 0..<8 {
                    for j in 0..<8 {
                        game.board[i][j].selected = false;
                    }
                }

                game.board[tile_x][tile_y].selected = true;
                
                selected_tile = game.board[tile_x][tile_y];
                fmt.print("selected x:");
                fmt.print(selected_tile.x);
                fmt.print("\t");
                fmt.print("selected_y");
                fmt.println(selected_tile.y);
                fmt.print("selected owner: \t");
                fmt.println(selected_tile.piece.owner);
                fmt.print("last_selected x:");
                fmt.print(last_selected_tile.x);
                fmt.print("\t");
                fmt.print("last_selected_y");
                fmt.println(last_selected_tile.y);
                fmt.print("last_selected owner: \t");
                fmt.println(last_selected_tile.piece.owner);
                fmt.print("Whos_turn:\t");
                fmt.println(game.whos_turn);


            }

            if selected_tile.can_move {

                for i in 0..<8 {
                    for j in 0..<8 {
                        game.board[i][j].can_move = false;
                    }
                }

                game.board[tile_x][tile_y].piece = last_selected_tile.piece;
                game.board[last_selected_tile.x][last_selected_tile.y].piece = Piece {};
                game.board[last_selected_tile.x][last_selected_tile.y].selected = false;
                selected_tile.piece = Piece{};

                if game.whos_turn == .White {
                    game.whos_turn = .Black;
                } else {
                    game.whos_turn = .White;
                }
                continue;
            }
        }

        

        if !selected_tile.selected {
            for i in 0..<8 {
                for j in 0..<8 {
                    game.board[i][j].can_move = false;
                }
            }

            
        } else if selected_tile.piece.owner != game.whos_turn {
            fmt.print("XXXXXXXXXXXXXXXXX");
            for i in 0..<8 {
                for j in 0..<8 {
                    game.board[i][j].selected = false;
                }
            }

            for i in 0..<8 {
                for j in 0..<8 {
                    game.board[i][j].can_move = false;
                }
            }

            last_selected_tile = Tile {
                piece = Piece {
                    type = PieceType.None,
                    owner = Side.None,
                    moved = false,
                },
                x = selected_tile.x,
                y = selected_tile.y,
            };

            selected_tile = Tile {
                piece = Piece {
                    type = PieceType.None,
                    owner = selected_tile.piece.owner,
                    moved = false,
                },
                x = selected_tile.x,
                y = selected_tile.y,
            };

        } else {

            switch selected_tile.piece.type {
                case .None: {

                    for i in 0..<8 {
                        for j in 0..<8 {
                            game.board[i][j].selected = false;
                        }
                    }

                    for i in 0..<8 {
                        for j in 0..<8 {
                            game.board[i][j].can_move = false;
                        }
                    }

                    last_selected_tile = Tile {
                        piece = Piece {
                            type = PieceType.None,
                            owner = Side.None,
                            moved = false,
                        },
                        x = selected_tile.x,
                        y = selected_tile.y,
                    };

                }
                case .Pawn: {
    
                    for i in 0..<8 {
                        for j in 0..<8 {
                            game.board[i][j].can_move = false;
                        }
                    }
                    
    
                    if selected_tile.piece.owner == Side.Black {
                        if !selected_tile.piece.moved {
                            game.board[selected_tile.x][sum8(selected_tile.y, 1)].can_move = true;
                            game.board[selected_tile.x][sum8(selected_tile.y, 2)].can_move = true;
                        } else if selected_tile.y < 7 {
                            game.board[selected_tile.x][sum8(selected_tile.y, 1)].can_move = true;
                        }
                    } else {
                        if !selected_tile.piece.moved {
                            game.board[selected_tile.x][diff8(selected_tile.y, 1)].can_move = true;
                            game.board[selected_tile.x][diff8(selected_tile.y, 2)].can_move = true;
                        } else if selected_tile.y < 7 {
                            game.board[selected_tile.x][diff8(selected_tile.y, 1)].can_move = true;
                        }
                    }

                    // game.board[last_selected_tile.x][last_selected_tile.y].selected = false;

                    last_selected_tile = Tile {
                        piece = Piece {
                            type = PieceType.Pawn,
                            owner = selected_tile.piece.owner,
                            moved = false,
                        },
                        x = selected_tile.x,
                        y = selected_tile.y,
                    };
                    

                }
                case .Knight: {
                    for i in 0..<8 {
                        for j in 0..<8 {
                            game.board[i][j].can_move = false;
                        }
                    }
    
                    if selected_tile.x - 1 >= 0 && selected_tile.y - 2 >= 0 {game.board[selected_tile.x - 1][selected_tile.y - 2].can_move = true;}
                    if selected_tile.x - 1 >= 0 && selected_tile.y + 2 < 8  {game.board[selected_tile.x - 1][selected_tile.y + 2].can_move = true;}
                    if selected_tile.x + 1 < 8 && selected_tile.y - 2 >= 0  {game.board[selected_tile.x + 1][selected_tile.y - 2].can_move = true;}
                    if selected_tile.x + 1 < 8 && selected_tile.y + 2 < 8   {game.board[selected_tile.x + 1][selected_tile.y + 2].can_move = true;}
                    if selected_tile.x - 2 >= 0 && selected_tile.y - 1 >= 0 {game.board[selected_tile.x - 2][selected_tile.y - 1].can_move = true;}
                    if selected_tile.x - 2 >= 0 && selected_tile.y + 1 < 8  {game.board[selected_tile.x - 2][selected_tile.y + 1].can_move = true;}
                    if selected_tile.x + 2 < 8 && selected_tile.y - 1 >= 0  {game.board[selected_tile.x + 2][selected_tile.y - 1].can_move = true;}
                    if selected_tile.x + 2 < 8 && selected_tile.y + 1 < 8   {game.board[selected_tile.x + 2][selected_tile.y + 1].can_move = true;}
                    
                    for i in 0..<8 {
                        for j in 0..<8 {
                            if !(game.board[i][j].piece.type == PieceType.None) && game.board[i][j].piece.owner == selected_tile.piece.owner {
                                game.board[i][j].can_move = false;
                            }
                        }
                    }

                    // game.board[last_selected_tile.x][last_selected_tile.y].selected = false;

                    last_selected_tile = Tile {
                        piece = Piece {
                            type = PieceType.Knight,
                            owner = selected_tile.piece.owner,
                            moved = false,
                        },
                        x = selected_tile.x,
                        y = selected_tile.y,
                    };

    
                }
                case .Bishop: {
                    for i in 0..<8 {
                        for j in 0..<8 {
                            game.board[i][j].can_move = false;
                        }
                    }

                    show_bishop_moves(&game, &selected_tile);

                    // game.board[last_selected_tile.x][last_selected_tile.y].selected = false;


                    last_selected_tile = Tile {
                        piece = Piece {
                            type = PieceType.Bishop,
                            owner = selected_tile.piece.owner,
                            moved = false,
                        },
                        x = selected_tile.x,
                        y = selected_tile.y,
                    };
                    
                }
                case .Rook: {
                    for i in 0..<8 {
                        for j in 0..<8 {
                            game.board[i][j].can_move = false;
                        }
                    }

                    show_rook_moves(&game, &selected_tile);

                    // game.board[last_selected_tile.x][last_selected_tile.y].selected = false;


                    last_selected_tile = Tile {
                        piece = Piece {
                            type = PieceType.Rook,
                            owner = selected_tile.piece.owner,
                            moved = false,
                        },
                        x = selected_tile.x,
                        y = selected_tile.y,
                    };

                }
                case .King: {
                    for i in 0..<8 {
                        for j in 0..<8 {
                            game.board[i][j].can_move = false;
                        }
                    }
                    x:= selected_tile.x;
                    y := selected_tile.y;
                    if set_can_move(&game, x-1, y-1) {if game.board[x-1][y-1].piece.owner == selected_tile.piece.owner {set_can_move(&game, x-1, y-1)}}
                    if set_can_move(&game, x-1, y  ) {if game.board[x-1][y  ].piece.owner == selected_tile.piece.owner {set_can_move(&game, x-1, y  )}}
                    if set_can_move(&game, x-1, y+1) {if game.board[x-1][y+1].piece.owner == selected_tile.piece.owner {set_can_move(&game, x-1, y+1)}}
                    if set_can_move(&game, x, y-1  ) {if game.board[x  ][y-1].piece.owner == selected_tile.piece.owner {set_can_move(&game, x,   y-1)}}
                    if set_can_move(&game, x, y+1  ) {if game.board[x  ][y+1].piece.owner == selected_tile.piece.owner {set_can_move(&game, x,   y+1)}}
                    if set_can_move(&game, x+1, y-1) {if game.board[x+1][y-1].piece.owner == selected_tile.piece.owner {set_can_move(&game, x+1, y-1)}}
                    if set_can_move(&game, x+1, y  ) {if game.board[x+1][y  ].piece.owner == selected_tile.piece.owner {set_can_move(&game, x+1, y  )}}
                    if set_can_move(&game, x+1, y+1) {if game.board[x+1][y+1].piece.owner == selected_tile.piece.owner {set_can_move(&game, x+1, y+1)}}

                    // game.board[last_selected_tile.x][last_selected_tile.y].selected = false;


                    last_selected_tile = Tile {
                        piece = Piece {
                            type = PieceType.King,
                            owner = selected_tile.piece.owner,
                            moved = false,
                        },
                        x = selected_tile.x,
                        y = selected_tile.y,
                    };
                }
                case .Queen: {
                    for i in 0..<8 {
                        for j in 0..<8 {
                            game.board[i][j].can_move = false;
                        }
                    }

                    
                    // game.board[last_selected_tile.x][last_selected_tile.y].selected = false;

                    show_bishop_moves(&game, &selected_tile);
                    show_rook_moves(&game, &selected_tile);

                    last_selected_tile = Tile {
                        piece = Piece {
                            type = PieceType.Queen,
                            owner = selected_tile.piece.owner,
                            moved = false,
                        },
                        x = selected_tile.x,
                        y = selected_tile.y,
                    };
                }
            }
        }




        rl.BeginDrawing();
        render_board(&game, rl.LIGHTGRAY);
        


        rl.EndDrawing();
    }

}