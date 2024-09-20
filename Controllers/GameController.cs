using Microsoft.AspNetCore.Mvc;
using System;
using System.Linq;

[ApiController]
[Route("api/[controller]")]
public class GameController : ControllerBase
{
    private readonly GameContext _context;

    public GameController(GameContext context)
    {
        _context = context;
    }

    [HttpPost("guess")]
    public IActionResult MakeGuess([FromBody] GuessModel guess)
    {
        var game = _context.Games.FirstOrDefault();
        if (game == null)
        {
            return BadRequest("No game configured");
        }

        if (guess.Guess == game.SecretNumber)
        {
            return Ok(new { Message = "Correct! You won!" });
        }
        else if (guess.Guess < game.SecretNumber)
        {
            return Ok(new { Message = "Too low. Try again!" });
        }
        else
        {
            return Ok(new { Message = "Too high. Try again!" });
        }
    }
}

public class GuessModel
{
    public int Guess { get; set; }
}
