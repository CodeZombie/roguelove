GameMath = {}

function GameMath.sign(p1, p2, p3)
	return (p1.x - p3.x) * (p2.y - p3.y) - (p2.x - p3.x) * (p1.y - p3.y)
end

function GameMath.pointInTriangle(point, tri1, tri2, tri3)
	b1 = GameMath.sign(point, tri1, tri2) < 0
	b2 = GameMath.sign(point, tri2, tri3) < 0
	b3 = GameMath.sign(point, tri3, tri1) < 0

	return ((b1 == b2) and (b2 == b3))
end

function GameMath.round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function GameMath.sign(x_)
	return (x_ < 0 and -1) or 1
end
