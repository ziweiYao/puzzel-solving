#![allow(non_snake_case, non_camel_case_types, dead_code)]

use std::collections::HashMap;

fn boggle(board: &[&str], words: &Vec<String>) -> HashMap<String, Vec<(u8, u8)>> {
    let mut found: HashMap<String, Vec<(u8, u8)>> = HashMap::new();

    for word in words {
        let coords = find_word(board, word);
        if !coords.is_empty() {
            found.insert(word.clone(), coords);
        }
    }
    found
}

fn find_word(board: &[&str], word: &str) -> Vec<(u8, u8)> {
    let mut result: Vec<(u8, u8)> = Vec::new();

    for (row_index, row) in board.iter().enumerate() {
        for (col_index, letter) in row.chars().enumerate() {
            if let Some(first_letter) = word.chars().next() {
                if letter == first_letter {
                    if let Some(coords) = search_word(board, word, row_index as u8, col_index as u8, &mut vec![]) {
                        result.extend(coords);
                        return result; 
                    }
                }
            }
        }
    }

    result
}

fn search_word(board: &[&str], word: &str, row: u8, col: u8, visited: &mut Vec<(u8, u8)>) -> Option<Vec<(u8, u8)>> {

    if word.is_empty() {
        return Some(vec![]);
    }
    if row as usize >= board.len() || col as usize >= board[0].len() || visited.contains(&(row, col)) {
        return None;
    }
    if board[row as usize].chars().nth(col as usize) == word.chars().next() {
        visited.push((row, col));
        if word.len() == 1 {
            return Some(vec![(row, col)]);
        }
        for dr in -1..=1 {
            for dc in -1..=1 {
                if dr == 0 && dc == 0 {
                    continue;
                }
                let new_row = row.wrapping_add(dr as u8);
                let new_col = col.wrapping_add(dc as u8);
                if let Some(coords) = search_word(board, &word[1..], new_row, new_col, visited) {
                    let mut result = vec![(row, col)];
                    result.extend(coords);
                    return Some(result);
                }
            }
        }
        visited.pop();
    }

    None
}




#[cfg(test)]
#[path = "tests.rs"]
mod tests;