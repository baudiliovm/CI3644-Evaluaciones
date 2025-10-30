module p2_v

pub enum NodeKind { value op }

pub struct Node {
    kind NodeKind
    val  int
    op   string
    left  &Node = unsafe { nil }
    right &Node = unsafe { nil }
}

fn is_op(tok string) bool {
    return tok in ['+', '-', '*', '/']
}

pub fn eval(node &Node) int {
    if node.kind == .value {
        return node.val
    }
    a := eval(node.left)
    b := eval(node.right)
    return match node.op {
        '+' { a + b }
        '-' { a - b }
        '*' { a * b }
        '/' { a / b } // división entera
        else { 0 }
    }
}

// parse_pre returns the parsed node and the new position
pub fn parse_pre(tokens []string, pos int) (&Node, int) {
    tok := tokens[pos]
    mut cur := pos + 1
    if is_op(tok) {
        left_node, newpos := parse_pre(tokens, cur)
        cur = newpos
        right_node, newpos2 := parse_pre(tokens, cur)
        cur = newpos2
        node := Node{ kind: .op, op: tok, left: left_node, right: right_node }
        return &node, cur
    } else {
        v := tok.int()
        node := Node{ kind: .value, val: v }
        return &node, cur
    }
}

pub fn parse_post(tokens []string) &Node {
    mut stack := []&Node{}
    for tok in tokens {
        if is_op(tok) {
            if stack.len < 2 {
                node := Node{ kind: .value, val: 0 }
                return &node // malformed
            }
            right := stack[stack.len - 1]
            left := stack[stack.len - 2]
            stack = stack[0..stack.len - 2]
            node := Node{ kind: .op, op: tok, left: left, right: right }
            stack << &node
        } else {
            node := Node{ kind: .value, val: tok.int() }
            stack << &node
        }
    }
    if stack.len == 0 {
        node := Node{ kind: .value, val: 0 }
        return &node
    }
    return stack[stack.len - 1]
}

fn prec(op string) int {
    return match op {
        '+', '-' { 1 }
        '*', '/' { 2 }
        else { 3 }
    }
}

fn needs_paren(child &Node, parent_op string, is_right bool) bool {
    if child.kind == .value {
        return false
    }
    p_prec := prec(parent_op)
    c_prec := prec(child.op)
    if c_prec < p_prec {
        return true
    }
    if c_prec == p_prec && is_right {
        // parent is non-associative on right child for - and /
        if parent_op in ['-', '/'] {
            return true
        }
    }
    return false
}

pub fn to_infix(node &Node) string {
    if node.kind == .value {
        return node.val.str()
    }
    left_s := to_infix(node.left)
    right_s := to_infix(node.right)
    left_par := if needs_paren(node.left, node.op, false) { '(${left_s})' } else { left_s }
    right_par := if needs_paren(node.right, node.op, true) { '(${right_s})' } else { right_s }
    return '${left_par} ${node.op} ${right_par}'
}

pub fn parse_tokens_from_str(s string) []string {
    return s.trim_space().split(' ').filter(it != '')
}