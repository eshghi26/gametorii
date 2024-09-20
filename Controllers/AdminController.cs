using Microsoft.AspNetCore.Mvc;
using System;
using System.Linq;

[ApiController]
[Route("api/[controller]")]
public class AdminController : ControllerBase
{
    private readonly GameContext _context;

    public AdminController(GameContext context)
    {
        _context = context;
    }

    [HttpPost("config")]
    public IActionResult SaveConfig([FromBody] ConfigModel config)
    {
        var game = _context.Games.FirstOrDefault();
        if (game == null)
        {
            game = new Game();
            _context.Games.Add(game);
        }

        game.MaxNumber = config.MaxNumber;
        game.SecretNumber = new Random().Next(1, config.MaxNumber + 1);
        _context.SaveChanges();

        return Ok(new { Message = "Configuration saved successfully" });
    }
}

public class ConfigModel
{
    public int MaxNumber { get; set; }
}
