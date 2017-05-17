GameMath = {}

function GameMath.sign3(p1, p2, p3)
	return (p1.x - p3.x) * (p2.y - p3.y) - (p2.x - p3.x) * (p1.y - p3.y)
end

function GameMath.pointInTriangle(point, tri1, tri2, tri3)
	b1 = GameMath.sign3(point, tri1, tri2) < 0
	b2 = GameMath.sign3(point, tri2, tri3) < 0
	b3 = GameMath.sign3(point, tri3, tri1) < 0

	return ((b1 == b2) and (b2 == b3))
end

function GameMath.roundToDecimal(x_, n_)
	return GameMath.round(x_ * math.pow(10, n_)) * math.pow(0.1, n_)
end

function GameMath.round(x)
--  if x%2 ~= 0.5 then
    return math.floor(x+0.5)
--  end
--  return x-0.5
end

function GameMath.sign(x_)
	return (x_ < 0 and -1) or 1
end

function GameMath.max(int1, int2)
	if int1 > int2 then
		return int1
	else
		return int2
	end
end

function GameMath.min(int1, int2)
	if int1 < int2 then
		return int1
	else
		return int2
	end
end
